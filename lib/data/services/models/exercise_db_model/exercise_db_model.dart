import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_db_model.freezed.dart';

@freezed
abstract class ExerciseDbModel with _$ExerciseDbModel {
  factory ExerciseDbModel({
    int? exerciseId,
    required int workoutId,
    required String exerciseName,
    required int series,
    required int repeats,
    required double weight
  }) = _ExerciseDBModel;
}