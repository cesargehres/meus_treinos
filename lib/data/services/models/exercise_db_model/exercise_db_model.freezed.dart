// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_db_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExerciseDbModel implements DiagnosticableTreeMixin {

 int get exerciseId; int get workoutId; String get exerciseName; int get series; int get repeats; double get weight;
/// Create a copy of ExerciseDbModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseDbModelCopyWith<ExerciseDbModel> get copyWith => _$ExerciseDbModelCopyWithImpl<ExerciseDbModel>(this as ExerciseDbModel, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExerciseDbModel'))
    ..add(DiagnosticsProperty('exerciseId', exerciseId))..add(DiagnosticsProperty('workoutId', workoutId))..add(DiagnosticsProperty('exerciseName', exerciseName))..add(DiagnosticsProperty('series', series))..add(DiagnosticsProperty('repeats', repeats))..add(DiagnosticsProperty('weight', weight));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseDbModel&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.workoutId, workoutId) || other.workoutId == workoutId)&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.series, series) || other.series == series)&&(identical(other.repeats, repeats) || other.repeats == repeats)&&(identical(other.weight, weight) || other.weight == weight));
}


@override
int get hashCode => Object.hash(runtimeType,exerciseId,workoutId,exerciseName,series,repeats,weight);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExerciseDbModel(exerciseId: $exerciseId, workoutId: $workoutId, exerciseName: $exerciseName, series: $series, repeats: $repeats, weight: $weight)';
}


}

/// @nodoc
abstract mixin class $ExerciseDbModelCopyWith<$Res>  {
  factory $ExerciseDbModelCopyWith(ExerciseDbModel value, $Res Function(ExerciseDbModel) _then) = _$ExerciseDbModelCopyWithImpl;
@useResult
$Res call({
 int exerciseId, int workoutId, String exerciseName, int series, int repeats, double weight
});




}
/// @nodoc
class _$ExerciseDbModelCopyWithImpl<$Res>
    implements $ExerciseDbModelCopyWith<$Res> {
  _$ExerciseDbModelCopyWithImpl(this._self, this._then);

  final ExerciseDbModel _self;
  final $Res Function(ExerciseDbModel) _then;

/// Create a copy of ExerciseDbModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseId = null,Object? workoutId = null,Object? exerciseName = null,Object? series = null,Object? repeats = null,Object? weight = null,}) {
  return _then(_self.copyWith(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as int,workoutId: null == workoutId ? _self.workoutId : workoutId // ignore: cast_nullable_to_non_nullable
as int,exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as int,repeats: null == repeats ? _self.repeats : repeats // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseDbModel].
extension ExerciseDbModelPatterns on ExerciseDbModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseDBModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseDBModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseDBModel value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseDBModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseDBModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseDBModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int exerciseId,  int workoutId,  String exerciseName,  int series,  int repeats,  double weight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseDBModel() when $default != null:
return $default(_that.exerciseId,_that.workoutId,_that.exerciseName,_that.series,_that.repeats,_that.weight);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int exerciseId,  int workoutId,  String exerciseName,  int series,  int repeats,  double weight)  $default,) {final _that = this;
switch (_that) {
case _ExerciseDBModel():
return $default(_that.exerciseId,_that.workoutId,_that.exerciseName,_that.series,_that.repeats,_that.weight);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int exerciseId,  int workoutId,  String exerciseName,  int series,  int repeats,  double weight)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseDBModel() when $default != null:
return $default(_that.exerciseId,_that.workoutId,_that.exerciseName,_that.series,_that.repeats,_that.weight);case _:
  return null;

}
}

}

/// @nodoc


class _ExerciseDBModel with DiagnosticableTreeMixin implements ExerciseDbModel {
   _ExerciseDBModel({required this.exerciseId, required this.workoutId, required this.exerciseName, required this.series, required this.repeats, required this.weight});
  

@override final  int exerciseId;
@override final  int workoutId;
@override final  String exerciseName;
@override final  int series;
@override final  int repeats;
@override final  double weight;

/// Create a copy of ExerciseDbModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseDBModelCopyWith<_ExerciseDBModel> get copyWith => __$ExerciseDBModelCopyWithImpl<_ExerciseDBModel>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExerciseDbModel'))
    ..add(DiagnosticsProperty('exerciseId', exerciseId))..add(DiagnosticsProperty('workoutId', workoutId))..add(DiagnosticsProperty('exerciseName', exerciseName))..add(DiagnosticsProperty('series', series))..add(DiagnosticsProperty('repeats', repeats))..add(DiagnosticsProperty('weight', weight));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseDBModel&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.workoutId, workoutId) || other.workoutId == workoutId)&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.series, series) || other.series == series)&&(identical(other.repeats, repeats) || other.repeats == repeats)&&(identical(other.weight, weight) || other.weight == weight));
}


@override
int get hashCode => Object.hash(runtimeType,exerciseId,workoutId,exerciseName,series,repeats,weight);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExerciseDbModel(exerciseId: $exerciseId, workoutId: $workoutId, exerciseName: $exerciseName, series: $series, repeats: $repeats, weight: $weight)';
}


}

/// @nodoc
abstract mixin class _$ExerciseDBModelCopyWith<$Res> implements $ExerciseDbModelCopyWith<$Res> {
  factory _$ExerciseDBModelCopyWith(_ExerciseDBModel value, $Res Function(_ExerciseDBModel) _then) = __$ExerciseDBModelCopyWithImpl;
@override @useResult
$Res call({
 int exerciseId, int workoutId, String exerciseName, int series, int repeats, double weight
});




}
/// @nodoc
class __$ExerciseDBModelCopyWithImpl<$Res>
    implements _$ExerciseDBModelCopyWith<$Res> {
  __$ExerciseDBModelCopyWithImpl(this._self, this._then);

  final _ExerciseDBModel _self;
  final $Res Function(_ExerciseDBModel) _then;

/// Create a copy of ExerciseDbModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseId = null,Object? workoutId = null,Object? exerciseName = null,Object? series = null,Object? repeats = null,Object? weight = null,}) {
  return _then(_ExerciseDBModel(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as int,workoutId: null == workoutId ? _self.workoutId : workoutId // ignore: cast_nullable_to_non_nullable
as int,exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as int,repeats: null == repeats ? _self.repeats : repeats // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
