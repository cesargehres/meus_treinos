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
}
