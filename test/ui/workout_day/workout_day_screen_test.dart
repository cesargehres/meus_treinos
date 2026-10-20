import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meus_treinos/data/repositories/workouts/workout_repository.dart';
import 'package:meus_treinos/data/services/local/database_local_interface.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';
import 'package:meus_treinos/ui/workout_day/view_model/workout_day_view_model.dart';
import 'package:meus_treinos/ui/workout_day/widgets/workout_day_screen.dart';
import 'package:result_dart/result_dart.dart';

class _DataBaseLocalNaoUsado implements DataBaseLocalInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _FakeWorkoutRepository extends WorkoutRepository {
  _FakeWorkoutRepository() : super(dataBaseLocal: _DataBaseLocalNaoUsado());

  late Future<Result<Workout>> Function() nextResult;

  @override
  Future<Result<Workout>> getWorkoutByWeekday({required int weekday}) {
    return nextResult();
  }
}

// O treino padrão que o Meus Treinos cria antes de o usuário configurar o dia.
final Workout _defaultSaturday = Workout(
  workoutId: 6,
  workoutPlanId: 1,
  workoutName: 'sem treino',
  weekday: 6,
);

final Workout _configuredSaturday = _defaultSaturday.copyWith(
  workoutName: 'pernas',
  exercises: [
    Exercise(
      exerciseId: 1,
      workoutId: 6,
      exerciseName: 'Agachamento',
      series: 4,
      repeats: 10,
      weight: 60,
      restMinSeconds: null,
      restMaxSeconds: null,
      notes: null,
    ),
  ],
);

void main() {
  late _FakeWorkoutRepository repository;
  late WorkoutDayViewModel viewModel;

  setUp(() {
    repository = _FakeWorkoutRepository();
    viewModel = WorkoutDayViewModel(workoutRepository: repository);
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: WorkoutDayScreen(viewModel: viewModel)),
    );
    // Roda o postFrameCallback que dispara a busca.
    await tester.pump();
  }

  testWidgets('mostra o loading, e não o treino carregado antes, enquanto busca', (
    tester,
  ) async {
    repository.nextResult = () async => Success(_defaultSaturday);
    await viewModel.getWorkoutDay.execute();

    final Completer<Result<Workout>> pending = Completer();
    repository.nextResult = () => pending.future;
    await pumpScreen(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Sem Treino'), findsNothing);

    pending.complete(Success(_configuredSaturday));
    await tester.pump();

    expect(find.text('Pernas'), findsOneWidget);
    expect(find.text('Agachamento'), findsOneWidget);
  });

  testWidgets('quando a busca falha, não mostra o treino carregado antes', (
    tester,
  ) async {
    repository.nextResult = () async => Success(_configuredSaturday);
    await viewModel.getWorkoutDay.execute();

    repository.nextResult = () async => Failure(Exception('erro'));
    await pumpScreen(tester);
    await tester.pump();

    expect(find.text('Pernas'), findsNothing);
    expect(find.text('Sem Treino'), findsOneWidget);
  });

  testWidgets('busca de novo quando o app volta do segundo plano', (
    tester,
  ) async {
    repository.nextResult = () async => Success(_defaultSaturday);
    await pumpScreen(tester);
    await tester.pump();
    expect(find.text('Sem Treino'), findsOneWidget);

    void changeLifecycle(List<AppLifecycleState> states) {
      for (final AppLifecycleState state in states) {
        tester.binding.handleAppLifecycleStateChanged(state);
      }
    }

    changeLifecycle([
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]);
    repository.nextResult = () async => Success(_configuredSaturday);
    changeLifecycle([
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]);
    await tester.pump();
    await tester.pump();

    expect(find.text('Pernas'), findsOneWidget);
    expect(find.text('Agachamento'), findsOneWidget);
  });
}
