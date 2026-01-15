import 'package:flutter/foundation.dart';
import 'package:meus_treinos/data/repositories/workouts/workout_repository_interface.dart';
import 'package:meus_treinos/data/services/local/database_local_interface.dart';
import 'package:meus_treinos/data/services/models/exercise_db_model/exercise_db_model.dart';
import 'package:meus_treinos/data/services/models/workout_db_model/workout_db_model.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';
import 'package:meus_treinos/data/services/exceptions/exceptions.dart';
import 'package:result_dart/result_dart.dart';

class WorkoutRepository implements WorkoutRepositoryInterface {
  final DataBaseLocalInterface _dataBaseLocal;

  List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  Workout? _currentWorkout;
  Workout? get currentWorkout => _currentWorkout;

  WorkoutRepository({
    required dataBaseLocal
  }) : _dataBaseLocal = dataBaseLocal;

  @override
  Future<Result<Exercise>> createExercise({required Exercise exercise}) async {
    try {
      final ExerciseDbModel result = await _dataBaseLocal.createExercise(
        exerciseDbModel: ExerciseDbModel(
          workoutId: exercise.workoutId,
          exerciseName: exercise.exerciseName,
          series: exercise.series,
          repeats: exercise.repeats,
          weight: exercise.weight,
        ),
      );

      final Exercise newExercise = Exercise(
        exerciseId: result.exerciseId,
        workoutId: result.workoutId,
        exerciseName: result.exerciseName,
        series: result.series,
        repeats: result.repeats,
        weight: result.weight,
      );

      for (int index = 0; index < _workouts.length; index++) {
        if (_workouts[index].workoutId == newExercise.workoutId) {
          _workouts[index] = _workouts[index].copyWith(
            exercises: [..._workouts[index].exercises, newExercise]
          );

          _currentWorkout = _workouts[index];
          break;
        }
      }

      return Success(
        newExercise
      );
    } on DataBaseLocalException catch (e) {
      debugPrint('[${e.code}] ${e.message}');
      debugPrint(e.technicalMessage);

      return Failure(e);
    } catch (e) {
      debugPrint(e.toString());
      return Failure(
        Exception('Houve um erro inesperado!')
      );
    }
  }

  @override
  Future<Result<Workout>> createWorkout({required Workout workout}) async {
    try {
      final WorkoutDbModel result = await _dataBaseLocal.createWorkout(workoutDbModel: WorkoutDbModel(
        workoutName: workout.workoutName,
        weekday: workout.weekday,
      ));

      final Workout resultWorkout = Workout(
        workoutId: result.workoutId,
        workoutName: result.workoutName,
        weekday: result.weekday,
        exercises: <Exercise>[]
      );

      _workouts.add(resultWorkout);
      return Success(resultWorkout);
    } on DataBaseLocalException catch (e) {
      debugPrint('[${e.code}] ${e.message}');
      debugPrint(e.technicalMessage);

      return Failure(e);
    } catch (e) {
      debugPrint(e.toString());

      return Failure(
        Exception('Houve um erro inesperado!')
      );
    }
  }

  @override
  Future<Result<Workout>> getWorkoutByWeekday({required int weekday}) {
    // TODO: implement getWorkoutByWeekday
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Workout>>> getWorkouts() async {
    try {
      final List<WorkoutDbModel> result = await _dataBaseLocal.readWorkouts();

      List<Workout> workouts = result.map((workoutDbModel) {
        return Workout(
          workoutId: workoutDbModel.workoutId,
          workoutName: workoutDbModel.workoutName,
          weekday: workoutDbModel.weekday,
          exercises: <Exercise>[]
        );
      }).toList();

      for (int c = 0; c < workouts.length; c++) {
        final List<ExerciseDbModel> resultExercisesDbModel = await _dataBaseLocal.readExercisesByWorkout(workoutId: workouts[c].workoutId!);

        final List<Exercise> exercises = resultExercisesDbModel.map((exerciseDbModel) {
          return Exercise(
            exerciseId: exerciseDbModel.exerciseId,
            workoutId: exerciseDbModel.workoutId,
            exerciseName: exerciseDbModel.exerciseName,
            series: exerciseDbModel.series,
            repeats: exerciseDbModel.repeats,
            weight: exerciseDbModel.weight
          );
        }).toList();

        workouts[c] = workouts[c].copyWith(
          exercises: exercises
        );
      }

      _workouts = workouts;
      return Success(workouts);
    } on DataBaseLocalException catch (e) {
      debugPrint('[${e.code}] ${e.message}');
      debugPrint(e.technicalMessage);

      return Failure(e);
    } catch (e) {
      debugPrint(e.toString());

      return Failure(
        Exception('Houve um erro inesperado!')
      );
    }
  }

  @override
  Future<Result<Exercise>> updateExercise({required Exercise exercise}) async {
    try {
      final ExerciseDbModel exerciseDbModel = await _dataBaseLocal.updateExercise(
        exerciseDbModel: ExerciseDbModel(
          exerciseId: exercise.exerciseId,
          workoutId: exercise.workoutId,
          exerciseName: exercise.exerciseName,
          series: exercise.series,
          repeats: exercise.repeats,
          weight: exercise.weight
        )
      );

      final Exercise updatedExercise = Exercise(
        exerciseId: exerciseDbModel.exerciseId,
        workoutId: exerciseDbModel.workoutId,
        exerciseName: exerciseDbModel.exerciseName,
        series: exerciseDbModel.series,
        repeats: exerciseDbModel.repeats,
        weight: exerciseDbModel.weight
      );

      final workoutIndex = _workouts.indexWhere(
        (workout) => workout.workoutId == updatedExercise.workoutId,
      );

      if (workoutIndex == -1) {
        return Failure(Exception('Exercício não encontrado  no cache'));
      }

      final exercises = _workouts[workoutIndex].exercises;

      final exerciseIndex = exercises.indexWhere(
        (e) => e.exerciseId == updatedExercise.exerciseId,
      );

      if (exerciseIndex == -1) {
        return Failure(Exception('Exercício não encontrado no cache'));
      }

      final updatedExercises = [...exercises];
      updatedExercises[exerciseIndex] = updatedExercise;

      final updatedWorkout = _workouts[workoutIndex].copyWith(
        exercises: updatedExercises,
      );

      _currentWorkout = updatedWorkout;
      _workouts[workoutIndex] = updatedWorkout;

      return Success(updatedExercise);
    } on DataBaseLocalException catch (e) {
      debugPrint('[${e.code}] ${e.message}');
      debugPrint(e.technicalMessage);

      return Failure(e);
    } catch (e) {
      debugPrint(e.toString());

      return Failure(
        Exception('Houve um erro inesperado!')
      );
    }
  }

  @override
  Future<Result<Unit>> deleteExercise({required Exercise exercise}) async {
    try {
      await _dataBaseLocal.deleteExercise(exerciseId: exercise.exerciseId!);

      final workoutIndex = _workouts.indexWhere(
            (workout) => workout.workoutId == exercise.workoutId,
      );

      if (workoutIndex != -1) {
        _workouts[workoutIndex] = _workouts[workoutIndex].copyWith(
          exercises: _workouts[workoutIndex]
            .exercises
            .where((e) => e.exerciseId != exercise.exerciseId)
            .toList(),
        );
        _currentWorkout = _workouts[workoutIndex];
      }

      return Success(unit);
    } on DataBaseLocalException catch (e) {
      debugPrint('[${e.code}] ${e.message}');
      debugPrint(e.technicalMessage);

      return Failure(e);
    } catch (e) {
      return Failure(
        Exception(e)
      );
    }
  }

  Future<Result<Unit>> loadCurrentWorkout(Workout workout) async {
    try {
      _currentWorkout = workout;
      print(_currentWorkout);
      return Success(unit);
    } catch(e) {
      return Failure(
        Exception(e)
      );
    }
  }
}