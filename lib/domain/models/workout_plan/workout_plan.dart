import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_plan.freezed.dart';

/// Ficha de treino: os treinos da semana (ex: "Ficha 1", "Ficha 2"). Só uma
/// ficha fica ativa por vez, e é ela que define o treino de cada dia.
@freezed
abstract class WorkoutPlan with _$WorkoutPlan {
  factory WorkoutPlan({
    int? workoutPlanId,
    required String workoutPlanName,
    required bool isActive,
  }) = _WorkoutPlan;
}
