import 'package:flutter/cupertino.dart';
import 'package:meus_treinos/data/repositories/workouts/workout_repository.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';

import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class WorkoutsManagerViewModel extends ChangeNotifier {
  final WorkoutRepository _workoutRepository;

  List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  // Commands
  late final Command0<Unit> getAllWorkouts;
  late final Command1<Unit, Workout> replaceWorkout;

  WorkoutsManagerViewModel({
    required workoutRepository
  }) : _workoutRepository = workoutRepository {
    getAllWorkouts = Command0<Unit>(_getAllWorkouts);
    replaceWorkout = Command1<Unit, Workout>(_replaceWorkout);
  }

  AsyncResult<Unit> _getAllWorkouts() async {
    var result = await _workoutRepository.getWorkouts();
    result.onSuccess((listWorkouts) {
      _workouts = listWorkouts;
    });

    if (workouts.length < 7) {
      for (int c = 1; c <= 7; c++) {
        await _workoutRepository.createWorkout(
          workout: Workout(
            workoutName: 'Sem Treino', weekday: c
          )
        );
      }

      result = await _workoutRepository.getWorkouts();

      result.onSuccess((success) {
        _workouts = success;
      });
    }

    notifyListeners();
    return Success(unit);
  }

  AsyncResult<Unit> _replaceWorkout(Workout workout) async {
    _workouts = workouts.map((workoutInWorkouts) {
      if (workoutInWorkouts.workoutId == workout.workoutId) {
        return workout;
      } else {
        return workoutInWorkouts;
      }
    }).toList();

    notifyListeners();
    return Success(unit);
  }
}