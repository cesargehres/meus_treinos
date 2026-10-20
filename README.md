# Meus Treinos

App mobile em Flutter para organizar a rotina de musculação da semana. Cada dia tem um treino, cada treino tem seus exercícios (séries, repetições, carga, descanso e observações), e a tela inicial já mostra o treino do dia. Tudo funciona offline, com os dados salvos localmente em SQLite.

**Repositório:** [github.com/cesargehres/meus_treinos](https://github.com/cesargehres/meus_treinos)

<p align="center">
  <img src="docs/treino_do_dia.png" width="200" alt="Treino do dia" />
  <img src="docs/meus_treinos.png" width="200" alt="Meus treinos" />
  <img src="docs/detalhes.png" width="200" alt="Detalhes do treino" />
  <img src="docs/editar_exercicio.png" width="200" alt="Editar exercício" />
</p>

## Funcionalidades

- **Treino do dia:** ao abrir o app, mostra o treino do dia da semana atual com a lista de exercícios. Ao voltar para o app depois de um tempo em segundo plano, a tela é atualizada, então o treino certo aparece mesmo se o dia tiver virado.
- **Planejamento semanal:** um treino para cada dia, de segunda a domingo, criado automaticamente.
- **Gerenciamento de exercícios:** adicionar, editar e excluir exercícios, com confirmação antes de excluir.
- **Descanso:** cada exercício tem uma faixa de descanso obrigatória, com mínimo e máximo em segundos (exibida como `45 a 60s`). Exercícios salvos antes dessa versão aparecem como "Não definido" até serem editados.
- **Observações:** até 150 caracteres por exercício, como ajuste do aparelho ou cuidados na execução. Aparecem por inteiro no Treino do dia, sem precisar tocar em nada durante o treino, e resumidas em até 2 linhas na tela de detalhes.
- **Ordem dos exercícios:** na tela de detalhes do treino, segure um exercício e arraste para mudar a ordem. O Treino do dia segue a mesma ordem.
- **Renomear treinos:** por exemplo, "Peito e Tríceps" ou "Pernas".
- **Validação de formulário:** aceita peso com vírgula ou ponto (`20,5` ou `20.5`) e não deixa o descanso máximo ser menor que o mínimo.
- **100% offline:** persistência local com SQLite.

## Tecnologias

| Finalidade | Pacote |
| --- | --- |
| Framework | [Flutter](https://flutter.dev) (Dart 3.9) |
| Injeção de dependência | [provider](https://pub.dev/packages/provider) |
| Navegação | [go_router](https://pub.dev/packages/go_router) (`ShellRoute` com bottom navigation) |
| Tratamento de erros | [result_dart](https://pub.dev/packages/result_dart) |
| Estado de ações assíncronas | [result_command](https://pub.dev/packages/result_command) |
| Modelos imutáveis | [freezed](https://pub.dev/packages/freezed) |
| Banco de dados local | [sqflite](https://pub.dev/packages/sqflite) |

## Arquitetura

O projeto segue o [guia oficial de arquitetura do Flutter](https://docs.flutter.dev/app-architecture): MVVM com camadas de UI, domínio e dados.

```mermaid
flowchart LR
    subgraph UI
        W[Widgets / Screens] --> VM[ViewModels]
    end
    subgraph Domain
        M[Models<br/>WorkoutPlan, Workout, Exercise]
    end
    subgraph Data
        R[WorkoutRepository] --> S[DataBaseLocalSqlite]
    end
    VM --> R
    S --> DB[(SQLite)]
    VM -.usa.-> M
    R -.converte para.-> M
```

- **Widgets:** só desenham a tela e repassam as ações do usuário para o ViewModel.
- **ViewModels:** expõem o estado da tela e as ações como `Command`s. Cada `Command` informa por si só se está executando, se terminou com sucesso ou se falhou, e isso controla os loadings da interface.
- **Repository:** é a fonte da verdade para a UI. Converte os modelos do banco nos modelos de domínio e devolve `Result<T>` em vez de lançar exceções.
- **Service (SQLite):** acessa o banco por trás da interface `DataBaseLocalInterface`, então a implementação pode ser trocada, por exemplo por uma versão fake nos testes.

### Decisões técnicas

- **Result pattern em vez de exceções:** os erros fazem parte do tipo de retorno (`Result<Workout>`), então quem chama é obrigado a tratar o caso de falha.
- **Exceções tipadas na camada de dados:** a `DataBaseLocalException` carrega uma mensagem para o usuário, uma mensagem técnica para log e um `code` (ex: `SQLITE_DELETE_EXERCISE_NOT_FOUND`).
- **Modelos de banco separados dos de domínio:** `WorkoutDbModel` e `Workout` evoluem de forma independente, e a UI não depende do formato das tabelas.
- **Fichas de treino:** os treinos da semana pertencem a uma ficha (tabela `workout_plans`), e só uma ficha fica ativa por vez. Por enquanto o app usa uma única ficha, criada automaticamente, mas a estrutura já está pronta para ter várias fichas e alternar entre elas.
- **Integridade no banco:** chaves estrangeiras habilitadas (`PRAGMA foreign_keys`) e `ON DELETE CASCADE` de fichas para treinos e de treinos para exercícios.
- **Migração do banco:** o banco está na versão 3. Quem já usava o app recebe pelo `onUpgrade` as colunas de descanso, observações e ordem dos exercícios (versão 2) e a tabela de fichas (versão 3), com os treinos que já existiam ligados a uma ficha padrão. Treinos e exercícios continuam iguais, sem perda de dados.

### Estrutura de pastas

```
lib/
├── data/
│   ├── repositories/workouts/   # WorkoutRepository e sua interface
│   └── services/
│       ├── local/               # Implementação SQLite e interface
│       ├── models/              # Modelos do banco (freezed)
│       └── exceptions/          # Exceções tipadas
├── domain/models/               # WorkoutPlan, Workout, Exercise (freezed)
├── ui/
│   ├── app/                     # MaterialApp, rotas e bottom navigation
│   ├── shared/                  # Bottom sheets e diálogos reutilizáveis
│   ├── workout_day/             # Tela "Treino do Dia"
│   ├── workouts_manager/        # Tela "Meus Treinos"
│   └── workout_details/         # Detalhes e edição de um treino
└── utils/                       # Extensões de String e de int
```

Cada feature em `ui/` tem uma pasta `view_model/` e uma pasta `widgets/`.

## Como rodar

Pré-requisitos: [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.35 ou superior (Dart 3.9) e um emulador ou dispositivo Android/iOS.

```bash
git clone https://github.com/cesargehres/meus_treinos.git
cd meus_treinos
flutter pub get
flutter run
```

Os arquivos gerados pelo freezed (`*.freezed.dart`) já estão versionados. Se você alterar algum modelo, gere esses arquivos de novo:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Testes

Testes de unidade e de widget:

```bash
flutter test
```

A migração do banco tem testes de integração, que rodam com o SQLite de verdade num emulador ou celular:

```bash
flutter test integration_test --no-uninstall -d <id do aparelho>
```

Os testes usam um arquivo de banco separado e não mexem nos treinos do app. Mesmo assim, use o `--no-uninstall`: sem ele, o Flutter desinstala o app no fim do teste e os treinos salvos no aparelho são apagados junto.

## Autor

Feito por [César Gehres](https://github.com/cesargehres).
