import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class WorkoutRepositoryInterface {
  // Os treinos da semana são sempre os da ficha ativa.
  Future<Result<List<Workout>>> getWorkouts();
  Future<Result<Workout>> getWorkoutByWeekday({required int weekday});
  Future<Result<Workout>> createWorkout({required Workout workout});
  Future<Result<Exercise>> createExercise({required Exercise exercise});
  Future<Result<Exercise>> updateExercise({required Exercise exercise});
  Future<Result<Unit>> reorderExercises({
    required int workoutId,
    required List<Exercise> exercises,
  });
  Future<Result<Workout>> updateWorkout({required Workout workout});
  Future<Result<Unit>> deleteExercise({required Exercise exercise});
  Future<Result<Unit>> loadCurrentWorkout(Workout workout);
}