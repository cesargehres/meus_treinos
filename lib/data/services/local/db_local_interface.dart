import 'package:meus_treinos/data/services/models/exercise_db_model/exercise_db_model.dart';
import 'package:meus_treinos/data/services/models/workout_db_model/workout_db_model.dart';

abstract interface class DataBaseLocalInterface {
  // ---------- READ ----------
  Future<List<WorkoutDbModel>> readWorkouts();
  Future<WorkoutDbModel> readWorkout({required int workoutId});
  Future<WorkoutDbModel> readWorkoutByWeekday({required int weekday});
  Future<ExerciseDbModel> readExercise({required int exerciseId});

  // ---------- CREATE ----------
  Future<WorkoutDbModel> createWorkout({
    required WorkoutDbModel workoutDbModel
  });

  Future<ExerciseDbModel> createExercise({
    required ExerciseDbModel exerciseDbModel
  });

  // ---------- UPDATE ----------
  Future<WorkoutDbModel> updateWorkout({
    required WorkoutDbModel workoutDbModel
  });

  Future<ExerciseDbModel> updateExercise({
    required ExerciseDbModel exerciseDbModel
  });


  // ---------- DELETE ----------
  Future<void> deleteExercise({required int exerciseId});

  Future<void> deleteWorkout({required int workoutId});
}