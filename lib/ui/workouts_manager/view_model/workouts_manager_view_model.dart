import 'package:flutter/cupertino.dart';
import 'package:meus_treinos/data/repositories/workouts/workout_repository.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';

import 'package:result_command/result_command.dart';
import 'package:result_dart/functions.dart';
import 'package:result_dart/result_dart.dart';

class WorkoutsManagerViewModel extends ChangeNotifier {
  final WorkoutRepository _workoutRepository;

  List<Workout> get workouts => _workoutRepository.workouts;

  // Commands
  late final Command0<Unit> getAllWorkouts;
  late final Command1<Unit, Workout> replaceWorkout;
  late final Command1<Unit, Workout> loadCurrentWorkout;

  WorkoutsManagerViewModel({
    required workoutRepository
  }) : _workoutRepository = workoutRepository {
    getAllWorkouts = Command0<Unit>(_getAllWorkouts);
    replaceWorkout = Command1<Unit, Workout>(_replaceWorkout);
    loadCurrentWorkout = Command1<Unit, Workout>(_loadCurrentWorkout);
  }

  AsyncResult<Unit> _getAllWorkouts() async {
    var result = await _workoutRepository.getWorkouts();
    Exception? newFailure;

    result.onFailure((failure) {
      newFailure = failure;
    });

    if (newFailure != null) {
      return Failure(newFailure!);
    }

    if (workouts.length < 7) {
      final List<int> existingWeekdays = [];

      for (Workout workout in workouts) {
        if ([1, 2, 3, 4, 5, 6, 7].contains(workout.weekday)) {
          existingWeekdays.add(workout.weekday);
        }
      }

      for (int c = 1; c <= 7; c++) {
        if (!existingWeekdays.contains(c)) {
          var createWorkoutResult = await _workoutRepository.createWorkout(
            workout: Workout(
              workoutName: 'Sem Treino', weekday: c
            )
          );

          createWorkoutResult.onFailure((failure) {
            newFailure = failure;
          });

          if (newFailure != null) {
            return Failure(newFailure!);
          }
        }
      }

      result = await _workoutRepository.getWorkouts();

      result.onFailure((failure) {
        newFailure = failure;
      });

      if (newFailure != null) {
        return Failure(newFailure!);
      }
    }

    notifyListeners();
    return Success(unit);
  }

  AsyncResult<Unit> _replaceWorkout(Workout workout) async {
    notifyListeners();
    return Success(unit);
  }

  AsyncResult<Unit> _loadCurrentWorkout(Workout workout) async {
    var result = await _workoutRepository.loadCurrentWorkout(workout);

    return result.fold((success) {
      notifyListeners();
      return Success(unit);
    }, (failure) {
      return Failure(failure);
    });
  }
 }