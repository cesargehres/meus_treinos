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

      return Success(
        Exercise(
          exerciseId: result.exerciseId,
          workoutId: result.workoutId,
          exerciseName: result.exerciseName,
          series: result.series,
          repeats: result.repeats,
          weight: result.weight,
        ),
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
  Future<Result<Unit>> deleteExercise({required idExercise}) async {
    try {
      await _dataBaseLocal.deleteExercise(exerciseId: idExercise);

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

}