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
  late final Command1<Unit, Workout> updateWorkout;
  late final Command1<Unit, Exercise> updateExercise;
  late final Command1<Unit, Exercise> deleteExercise;
  late final Command2<Unit, int, int> reorderExercise;
  late final Command1<Unit, Workout> loadCurrentWorkout;

  WorkoutDetailsViewModel({
    required WorkoutRepository workoutRepository,
  }) : _workoutRepository = workoutRepository {
    createExercise = Command1<Unit, Exercise>(_createExercise);
    updateExercise = Command1<Unit, Exercise>(_updateExercise);
    updateWorkout = Command1<Unit, Workout>(_updateWorkout);
    deleteExercise = Command1<Unit, Exercise>(_deleteExercise);
    reorderExercise = Command2<Unit, int, int>(_reorderExercise);
    loadCurrentWorkout = Command1<Unit, Workout>(_loadCurrentWorkout);
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

  AsyncResult<Unit> _updateWorkout(Workout workout) async {
    var result = await _workoutRepository.updateWorkout(workout: workout);

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

  AsyncResult<Unit> _reorderExercise(int oldIndex, int newIndex) async {
    // O ReorderableListView conta o destino com o item ainda na posição antiga.
    if (newIndex > oldIndex) newIndex -= 1;

    final List<Exercise> exercises = [...workout!.exercises];
    exercises.insert(newIndex, exercises.removeAt(oldIndex));

    final pendingResult = _workoutRepository.reorderExercises(
      workoutId: workout!.workoutId!,
      exercises: exercises,
    );
    // O repositório já trocou a ordem no cache; redesenha sem esperar o banco.
    notifyListeners();

    final result = await pendingResult;

    return result.fold((success) {
      return Success(unit);
    }, (failure) {
      notifyListeners();
      return Failure(failure);
    });
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