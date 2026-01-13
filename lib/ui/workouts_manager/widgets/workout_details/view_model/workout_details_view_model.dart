import 'package:flutter/cupertino.dart';
import 'package:meus_treinos/data/repositories/workouts/workout_repository.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';

class WorkoutDetailsViewModel extends ChangeNotifier {
  final WorkoutRepository _workoutRepository;
  final Workout? workout;

  WorkoutDetailsViewModel({
    required WorkoutRepository workoutRepository,
    required this.workout
  }) : _workoutRepository = workoutRepository;
}