import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';

@freezed
abstract class Exercise with _$Exercise {
  factory Exercise({
    int? exerciseId,
    required int workoutId,
    required String exerciseName,
    required int series,
    required int repeats,
    required double weight
  }) = _Exercise;
}