import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_db_model.freezed.dart';

@freezed
abstract class WorkoutDbModel with _$WorkoutDbModel {
  factory WorkoutDbModel({
    required int workoutId,
    required String workoutName,
    required int weekday
  }) = _WorkoutDbModel;
}