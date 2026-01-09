import 'package:meus_treinos/data/repositories/workouts/workout_repository_interface.dart';
import 'package:meus_treinos/data/services/local/database_local_interface.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';
import 'package:result_dart/result_dart.dart';

class WorkoutRepository implements WorkoutRepositoryInterface {
  final DataBaseLocalInterface dataBaseLocal;

  WorkoutRepository({required this.dataBaseLocal});

  @override
  Future<Result<Exercise>> createExercise({required exercise}) {
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