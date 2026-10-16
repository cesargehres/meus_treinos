// Roda no celular ou no emulador, com o banco SQLite de verdade:
//
//   flutter test integration_test --no-uninstall -d <id do aparelho>
//
// Sem o --no-uninstall, o Flutter desinstala o app no fim do teste e os
// treinos salvos no aparelho são apagados junto.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meus_treinos/data/repositories/workouts/workout_repository.dart';
import 'package:meus_treinos/data/services/local/database_local_sqlite.dart';
import 'package:meus_treinos/data/services/models/exercise_db_model/exercise_db_model.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';
import 'package:meus_treinos/ui/workouts_manager/view_model/workouts_manager_view_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Arquivo separado, para o teste nunca tocar no banco do app.
const String _testDbName = 'meus_treinos_test.db';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late String path;

  setUp(() async {
    DataBaseLocalSqlite.dbName = _testDbName;
    path = join(await getDatabasesPath(), _testDbName);
    await deleteDatabase(path);
  });

  tearDown(() async {
    await DataBaseLocalSqlite.closeDatabase();
    await deleteDatabase(path);
  });

  group('migração da versão 2 para a 3', () {
    testWidgets('liga todos os treinos à ficha padrão sem perder dados', (
      tester,
    ) async {
      await _createVersion2Database(path, workouts: _version2Workouts);

      final DataBaseLocalSqlite dataBase = DataBaseLocalSqlite();

      final workoutPlan = await dataBase.readActiveWorkoutPlan();
      expect(workoutPlan.workoutPlanName, 'Minha ficha');
      expect(workoutPlan.isActive, isTrue);

      final workouts = await dataBase.readWorkouts(
        workoutPlanId: workoutPlan.workoutPlanId!,
      );
      expect(
        workouts.map((w) => (w.workoutId, w.workoutName, w.weekday)).toList(),
        _version2Workouts,
      );

      // Exercícios continuam iguais e na ordem escolhida (não a do id).
      expect(await dataBase.readExercisesByWorkout(workoutId: 1), [
        _tricepsCorda,
        _supinoReto,
      ]);
      expect(await dataBase.readExercisesByWorkout(workoutId: 3), [
        _agachamento,
      ]);

      final Database db = await openDatabase(path);
      expect(await db.getVersion(), 3);
      expect(
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM workout_plans'),
        ),
        1,
      );
      expect(
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM workouts WHERE workout_plan_id IS NULL',
          ),
        ),
        0,
      );
      expect(await db.rawQuery('PRAGMA foreign_key_check'), isEmpty);
    });

    testWidgets('o repositório devolve os mesmos treinos de antes', (
      tester,
    ) async {
      await _createVersion2Database(path, workouts: _version2Workouts);

      final WorkoutRepository repository = WorkoutRepository(
        dataBaseLocal: DataBaseLocalSqlite(),
      );

      final List<Workout> workouts = (await repository.getWorkouts())
          .getOrThrow();
      final int workoutPlanId = repository.activeWorkoutPlan!.workoutPlanId!;

      expect(workouts, hasLength(7));
      expect(workouts.every((w) => w.workoutPlanId == workoutPlanId), isTrue);

      final Workout monday = (await repository.getWorkoutByWeekday(
        weekday: 1,
      )).getOrThrow();
      expect(monday.workoutName, 'peito e tríceps');
      expect(monday.exercises.map((e) => e.exerciseName), [
        'tríceps corda',
        'supino reto',
      ]);
      expect(monday.exercises.first.notes, 'polia na altura do peito');
    });

    testWidgets('completa os dias que faltavam dentro da ficha padrão', (
      tester,
    ) async {
      // Quem nunca abriu "Meus Treinos" na versão 2 não tem os 7 dias.
      await _createVersion2Database(
        path,
        workouts: [(1, 'peito e tríceps', 1)],
      );

      final WorkoutRepository repository = WorkoutRepository(
        dataBaseLocal: DataBaseLocalSqlite(),
      );
      final WorkoutsManagerViewModel viewModel = WorkoutsManagerViewModel(
        workoutRepository: repository,
      );

      await viewModel.getAllWorkouts.execute();

      expect(viewModel.getAllWorkouts.value.isSuccess, isTrue);
      expect(viewModel.workouts.map((w) => w.weekday), [1, 2, 3, 4, 5, 6, 7]);
      expect(viewModel.workouts.first.workoutName, 'peito e tríceps');
      expect(
        viewModel.workouts.every(
          (w) => w.workoutPlanId == repository.activeWorkoutPlan!.workoutPlanId,
        ),
        isTrue,
      );
    });
  });

  testWidgets('instalação nova cria a ficha padrão com os 7 treinos', (
    tester,
  ) async {
    final WorkoutRepository repository = WorkoutRepository(
      dataBaseLocal: DataBaseLocalSqlite(),
    );
    final WorkoutsManagerViewModel viewModel = WorkoutsManagerViewModel(
      workoutRepository: repository,
    );

    await viewModel.getAllWorkouts.execute();

    expect(repository.activeWorkoutPlan!.workoutPlanName, 'Minha ficha');
    expect(viewModel.workouts.map((w) => w.weekday), [1, 2, 3, 4, 5, 6, 7]);
    expect(
      viewModel.workouts.every((w) => w.workoutName == 'sem treino'),
      isTrue,
    );

    final Workout today = (await repository.getWorkoutByWeekday(
      weekday: DateTime.now().weekday,
    )).getOrThrow();
    expect(today.workoutName, 'sem treino');
  });
}

const List<(int, String, int)> _version2Workouts = [
  (1, 'peito e tríceps', 1),
  (2, 'costas e bíceps', 2),
  (3, 'pernas', 3),
  (4, 'sem treino', 4),
  (5, 'sem treino', 5),
  (6, 'sem treino', 6),
  (7, 'sem treino', 7),
];

final ExerciseDbModel _supinoReto = ExerciseDbModel(
  exerciseId: 1,
  workoutId: 1,
  exerciseName: 'supino reto',
  series: 4,
  repeats: 10,
  weight: 40.5,
  restMinSeconds: 60,
  restMaxSeconds: 90,
  notes: null,
);

final ExerciseDbModel _tricepsCorda = ExerciseDbModel(
  exerciseId: 2,
  workoutId: 1,
  exerciseName: 'tríceps corda',
  series: 3,
  repeats: 12,
  weight: 20,
  restMinSeconds: 45,
  restMaxSeconds: 60,
  notes: 'polia na altura do peito',
);

// Exercício salvo antes da versão 2: sem descanso nem observação.
final ExerciseDbModel _agachamento = ExerciseDbModel(
  exerciseId: 3,
  workoutId: 3,
  exerciseName: 'agachamento',
  series: 4,
  repeats: 8,
  weight: 60,
  restMinSeconds: null,
  restMaxSeconds: null,
  notes: null,
);

/// Monta um banco como o app na versão 2 deixava, com o esquema daquela versão.
Future<void> _createVersion2Database(
  String path, {
  required List<(int, String, int)> workouts,
}) async {
  final Database db = await openDatabase(
    path,
    version: 2,
    onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
    onCreate: (db, version) async {
      await db.execute("""
        CREATE TABLE workouts(
          workout_id INTEGER PRIMARY KEY AUTOINCREMENT,
          workout_name TEXT NOT NULL,
          weekday INTEGER NOT NULL
        )
      """);

      await db.execute("""
        CREATE TABLE exercises(
          exercise_id INTEGER PRIMARY KEY AUTOINCREMENT,
          workout_id INTEGER NOT NULL,
          exercise_name TEXT NOT NULL,
          series INTEGER NOT NULL,
          repeats INTEGER NOT NULL,
          weight REAL NOT NULL,
          rest_min_seconds INTEGER,
          rest_max_seconds INTEGER,
          notes TEXT,
          position INTEGER NOT NULL DEFAULT 0,
          FOREIGN KEY (workout_id) REFERENCES workouts (workout_id) ON DELETE CASCADE
        )
      """);
    },
  );

  for (final (workoutId, workoutName, weekday) in workouts) {
    await db.insert('workouts', {
      'workout_id': workoutId,
      'workout_name': workoutName,
      'weekday': weekday,
    });
  }

  final bool hasLegWorkout = workouts.any((w) => w.$1 == 3);

  // O tríceps foi movido para cima do supino: a posição não segue o id.
  final List<(ExerciseDbModel, int)> exercises = [
    (_supinoReto, 1),
    (_tricepsCorda, 0),
    if (hasLegWorkout) (_agachamento, 0),
  ];

  for (final (exercise, position) in exercises) {
    await db.insert('exercises', {
      'exercise_id': exercise.exerciseId,
      'workout_id': exercise.workoutId,
      'exercise_name': exercise.exerciseName,
      'series': exercise.series,
      'repeats': exercise.repeats,
      'weight': exercise.weight,
      'rest_min_seconds': exercise.restMinSeconds,
      'rest_max_seconds': exercise.restMaxSeconds,
      'notes': exercise.notes,
      'position': position,
    });
  }

  await db.close();
}
