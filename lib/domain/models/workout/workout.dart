import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meus_treinos/domain/models/exercise/exercise.dart';

part 'workout.freezed.dart';

@freezed
abstract class Workout with _$Workout {
  factory Workout({
    int? workoutId,
    required workoutName,
    required int weekday,
    @Default([]) List<Exercise> exercises
  }) = _Workout;
}