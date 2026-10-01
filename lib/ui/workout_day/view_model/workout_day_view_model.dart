import 'package:flutter/foundation.dart';
import 'package:meus_treinos/data/repositories/workouts/workout_repository.dart';
import 'package:meus_treinos/domain/models/workout/workout.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class WorkoutDayViewModel extends ChangeNotifier {
  final WorkoutRepository _workoutRepository;

  Workout? _workoutDay;
  Workout? get workoutDay => _workoutDay;

  late final Command0<Unit> getWorkoutDay;

  WorkoutDayViewModel({
    required WorkoutRepository workoutRepository,
  }) : _workoutRepository = workoutRepository {
    getWorkoutDay = Command0<Unit>(_getWorkoutDay);
  }

  AsyncResult<Unit> _getWorkoutDay() async {
    DateTime today = DateTime.now();
    int weekday = today.weekday;

    var result = await _workoutRepository.getWorkoutByWeekday(weekday: weekday);

    return result.fold((success) {
      _workoutDay = success;
      notifyListeners();
      return Success(unit);
    }, (failure) {
      return Failure(failure);
    });
  }
}