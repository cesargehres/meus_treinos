import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_plan_db_model.freezed.dart';

@freezed
abstract class WorkoutPlanDbModel with _$WorkoutPlanDbModel {
  factory WorkoutPlanDbModel({
    int? workoutPlanId,
    required String workoutPlanName,
    required bool isActive,
  }) = _WorkoutPlanDbModel;
}
