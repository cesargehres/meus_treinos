import 'package:flutter/cupertino.dart';
import 'package:meus_treinos/data/repositories/workouts/workout_repository.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class WorkoutDetailsViewModel extends ChangeNotifier {
  final WorkoutRepository _workoutRepository;
  Workout? workout;

  late final Command1<Unit, Exercise> createExercise;

  WorkoutDetailsViewModel({
    required WorkoutRepository workoutRepository,
    required this.workout
  }) : _workoutRepository = workoutRepository {
    createExercise = Command1<Unit, Exercise>(
      (Exercise exercise) async {
        var result = await _workoutRepository.createExercise(
          exercise: exercise
        );

        result.onSuccess((success) {
          workout = workout!.copyWith(
            exercises: [
              ...workout!.exercises,
              success
            ]
          );
        });

        notifyListeners();
        return Success(unit);
      });
  }
}