import 'package:meus_treinos/data/repositories/workouts/workout_repository_interface.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';
import 'package:result_dart/src/types.dart';

class WorkoutRepository implements WorkoutRepositoryInterface {
  @override
  Future<Result<Exercise>> createExercise({required exercise}) {
    // TODO: implement createExercise
    throw UnimplementedError();
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