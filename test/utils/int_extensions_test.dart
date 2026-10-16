import 'package:flutter_test/flutter_test.dart';
import 'package:meus_treinos/utils/int_extensions.dart';

void main() {
  group('restTime', () {
    test('menos de um minuto mostra só segundos', () {
      expect(0.restTime, '0s');
      expect(45.restTime, '45s');
    });

    test('minutos cheios mostram só minutos', () {
      expect(60.restTime, '1min');
      expect(120.restTime, '2min');
    });

    test('minutos e segundos mostram os dois', () {
      expect(90.restTime, '1min 30s');
      expect(150.restTime, '2min 30s');
    });
  });

  group('formatRestRange', () {
    test('sem descanso salvo mostra "Não definido"', () {
      expect(formatRestRange(null, null), 'Não definido');
      expect(formatRestRange(45, null), 'Não definido');
    });

    test('mínimo igual ao máximo mostra um valor só', () {
      expect(formatRestRange(60, 60), '1min');
      expect(formatRestRange(90, 90), '1min 30s');
    });

    test('faixa em minutos cheios mostra em minutos', () {
      expect(formatRestRange(120, 180), '2 a 3min');
    });

    test('demais faixas mostram em segundos', () {
      expect(formatRestRange(45, 60), '45 a 60s');
      expect(formatRestRange(60, 90), '60 a 90s');
    });
  });
}
