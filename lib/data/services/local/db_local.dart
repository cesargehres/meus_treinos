import 'package:meus_treinos/data/services/models/exercise_db_model/exercise_db_model.dart';
import 'package:meus_treinos/data/services/models/workout_db_model/workout_db_model.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class DataBaseLocal {
  // ---------- READ ----------
  Future<Result<List<WorkoutDbModel>>> readWorkouts();
  Future<Result<WorkoutDbModel>> readWorkout({required int workoutId});
  Future<Result<WorkoutDbModel>> readWorkoutByWeekday({required int weekday});
  Future<Result<ExerciseDbModel>> readExercise({required int exerciseId});

  // ---------- CREATE ----------
  Future<Result<WorkoutDbModel>> createWorkout({
    required String workoutName,
    required int weekday,
  });

  Future<Result<ExerciseDbModel>> createExercise({
    required int workoutId,
    required String exerciseName,
    required int series,
    required int repeats,
    required double weight
  });

  // ---------- UPDATE ----------
  Future<Result<WorkoutDbModel>> updateWorkout({
    required int workoutId,
    required String workoutName,
    required int weekday,
  });

  Future<Result<ExerciseDbModel>> updateExercise({
    required int exerciseId,
    required String exerciseName,
    required int series,
    required int repeats,
    required double weight
  });
}