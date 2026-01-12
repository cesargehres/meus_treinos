import 'package:flutter/foundation.dart';
import 'package:meus_treinos/data/repositories/workouts/workout_repository_interface.dart';
import 'package:meus_treinos/data/services/local/database_local_interface.dart';
import 'package:meus_treinos/data/services/models/exercise_db_model/exercise_db_model.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';
import 'package:meus_treinos/utils/exceptions.dart';
import 'package:result_dart/result_dart.dart';

class WorkoutRepository implements WorkoutRepositoryInterface {
  final DataBaseLocalInterface dataBaseLocal;

  WorkoutRepository({required this.dataBaseLocal});

  @override
  Future<Result<Exercise>> createExercise({required Exercise exercise}) async {
    try {
      final ExerciseDbModel dbModel = await dataBaseLocal.createExercise(
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
          exerciseId: dbModel.exerciseId,
          workoutId: dbModel.workoutId,
          exerciseName: dbModel.exerciseName,
          series: dbModel.series,
          repeats: dbModel.repeats,
          weight: dbModel.weight,
        ),
      );
    } on LocalStorageException catch (e) {
      debugPrint(e.technicalMessage);

      return const Failure(CreateExerciseFailure());
    } catch (_) {
      return const Failure(CreateExerciseFailure());
    }
  }

  @override
  Future<Result<Workout>> createWorkout({required Workout workout}) {
    // TODO: implement createWorkout
    throw UnimplementedError();
  }

  @override
  Future<Result<Workout>> getWorkoutByWeekday({required int weekday}) {
    // TODO: implement getWorkoutByWeekday
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Workout>>> getWorkouts() {
    // TODO: implement getWorkouts
    throw UnimplementedError();
  }

}