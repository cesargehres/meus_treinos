import 'package:meus_treinos/data/services/models/exercise_db_model/exercise_db_model.dart';
import 'package:meus_treinos/data/services/models/workout_db_model/workout_db_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class DataBaseLocalInterface {
  // ---------- READ ----------
  Future<Result<List<WorkoutDbModel>>> readWorkouts();
  Future<Result<WorkoutDbModel>> readWorkout({required int workoutId});
  Future<Result<WorkoutDbModel>> readWorkoutByWeekday({required int weekday});
  Future<Result<ExerciseDbModel>> readExercise({required int exerciseId});

  // ---------- CREATE ----------
  Future<Result<WorkoutDbModel>> createWorkout({
    required WorkoutDbModel workoutDbModel
  });

  Future<Result<ExerciseDbModel>> createExercise({
    required ExerciseDbModel exerciseDbModel
  });

  // ---------- UPDATE ----------
  Future<Result<WorkoutDbModel>> updateWorkout({
    required WorkoutDbModel workoutDbModel
  });

  Future<Result<ExerciseDbModel>> updateExercise({
    required ExerciseDbModel exerciseDbModel
  });


  // ---------- DELETE ----------
  Future<Result<Unit>> deleteExercise({required int exerciseId});

  Future<Result<Unit>> deleteWorkout({required int workoutId});
}