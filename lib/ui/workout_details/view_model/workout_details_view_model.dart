import 'package:flutter/cupertino.dart';
import 'package:meus_treinos/data/repositories/workouts/workout_repository.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class WorkoutDetailsViewModel extends ChangeNotifier {
  final WorkoutRepository _workoutRepository;

  Workout? get workout => _workoutRepository.currentWorkout;

  late final Command1<Unit, Exercise> createExercise;
  late final Command1<Unit, Exercise> updateExercise;
  late final Command1<Unit, Exercise> deleteExercise;

  WorkoutDetailsViewModel({
    required WorkoutRepository workoutRepository,
  }) : _workoutRepository = workoutRepository {
    createExercise = Command1<Unit, Exercise>(_createExercise);
    updateExercise = Command1<Unit, Exercise>(_updateExercise);
    deleteExercise = Command1<Unit, Exercise>(_deleteExercise);
  }

  AsyncResult<Unit> _createExercise(Exercise exercise) async {
    var result = await _workoutRepository.createExercise(exercise: exercise);

    return result.fold((success) {
      notifyListeners();
      return Success(unit);
    }, (failure) {
      return Failure(failure);
    });
  }

  AsyncResult<Unit> _updateExercise(Exercise exercise) async {
    var result = await _workoutRepository.updateExercise(exercise: exercise);

    return result.fold((success) {
      notifyListeners();
      return Success(unit);
    }, (failure) {
      return Failure(failure);
    });
  }

  AsyncResult<Unit> _deleteExercise(Exercise exercise) async {
    var result = await _workoutRepository.deleteExercise(exercise: exercise);

    return result.onSuccess((success) {
      notifyListeners();
    });
  }
}