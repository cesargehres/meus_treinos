// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_plan_db_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkoutPlanDbModel implements DiagnosticableTreeMixin {

 int? get workoutPlanId; String get workoutPlanName; bool get isActive;
/// Create a copy of WorkoutPlanDbModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutPlanDbModelCopyWith<WorkoutPlanDbModel> get copyWith => _$WorkoutPlanDbModelCopyWithImpl<WorkoutPlanDbModel>(this as WorkoutPlanDbModel, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'WorkoutPlanDbModel'))
    ..add(DiagnosticsProperty('workoutPlanId', workoutPlanId))..add(DiagnosticsProperty('workoutPlanName', workoutPlanName))..add(DiagnosticsProperty('isActive', isActive));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutPlanDbModel&&(identical(other.workoutPlanId, workoutPlanId) || other.workoutPlanId == workoutPlanId)&&(identical(other.workoutPlanName, workoutPlanName) || other.workoutPlanName == workoutPlanName)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,workoutPlanId,workoutPlanName,isActive);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'WorkoutPlanDbModel(workoutPlanId: $workoutPlanId, workoutPlanName: $workoutPlanName, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $WorkoutPlanDbModelCopyWith<$Res>  {
  factory $WorkoutPlanDbModelCopyWith(WorkoutPlanDbModel value, $Res Function(WorkoutPlanDbModel) _then) = _$WorkoutPlanDbModelCopyWithImpl;
@useResult
$Res call({
 int? workoutPlanId, String workoutPlanName, bool isActive
});




}
/// @nodoc
class _$WorkoutPlanDbModelCopyWithImpl<$Res>
    implements $WorkoutPlanDbModelCopyWith<$Res> {
  _$WorkoutPlanDbModelCopyWithImpl(this._self, this._then);

  final WorkoutPlanDbModel _self;
  final $Res Function(WorkoutPlanDbModel) _then;

/// Create a copy of WorkoutPlanDbModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workoutPlanId = freezed,Object? workoutPlanName = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
workoutPlanId: freezed == workoutPlanId ? _self.workoutPlanId : workoutPlanId // ignore: cast_nullable_to_non_nullable
as int?,workoutPlanName: null == workoutPlanName ? _self.workoutPlanName : workoutPlanName // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutPlanDbModel].
extension WorkoutPlanDbModelPatterns on WorkoutPlanDbModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutPlanDbModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutPlanDbModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutPlanDbModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutPlanDbModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutPlanDbModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutPlanDbModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? workoutPlanId,  String workoutPlanName,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutPlanDbModel() when $default != null:
return $default(_that.workoutPlanId,_that.workoutPlanName,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? workoutPlanId,  String workoutPlanName,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _WorkoutPlanDbModel():
return $default(_that.workoutPlanId,_that.workoutPlanName,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? workoutPlanId,  String workoutPlanName,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutPlanDbModel() when $default != null:
return $default(_that.workoutPlanId,_that.workoutPlanName,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutPlanDbModel with DiagnosticableTreeMixin implements WorkoutPlanDbModel {
   _WorkoutPlanDbModel({this.workoutPlanId, required this.workoutPlanName, required this.isActive});
  

@override final  int? workoutPlanId;
@override final  String workoutPlanName;
@override final  bool isActive;

/// Create a copy of WorkoutPlanDbModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutPlanDbModelCopyWith<_WorkoutPlanDbModel> get copyWith => __$WorkoutPlanDbModelCopyWithImpl<_WorkoutPlanDbModel>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'WorkoutPlanDbModel'))
    ..add(DiagnosticsProperty('workoutPlanId', workoutPlanId))..add(DiagnosticsProperty('workoutPlanName', workoutPlanName))..add(DiagnosticsProperty('isActive', isActive));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutPlanDbModel&&(identical(other.workoutPlanId, workoutPlanId) || other.workoutPlanId == workoutPlanId)&&(identical(other.workoutPlanName, workoutPlanName) || other.workoutPlanName == workoutPlanName)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,workoutPlanId,workoutPlanName,isActive);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'WorkoutPlanDbModel(workoutPlanId: $workoutPlanId, workoutPlanName: $workoutPlanName, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$WorkoutPlanDbModelCopyWith<$Res> implements $WorkoutPlanDbModelCopyWith<$Res> {
  factory _$WorkoutPlanDbModelCopyWith(_WorkoutPlanDbModel value, $Res Function(_WorkoutPlanDbModel) _then) = __$WorkoutPlanDbModelCopyWithImpl;
@override @useResult
$Res call({
 int? workoutPlanId, String workoutPlanName, bool isActive
});




}
/// @nodoc
class __$WorkoutPlanDbModelCopyWithImpl<$Res>
    implements _$WorkoutPlanDbModelCopyWith<$Res> {
  __$WorkoutPlanDbModelCopyWithImpl(this._self, this._then);

  final _WorkoutPlanDbModel _self;
  final $Res Function(_WorkoutPlanDbModel) _then;

/// Create a copy of WorkoutPlanDbModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workoutPlanId = freezed,Object? workoutPlanName = null,Object? isActive = null,}) {
  return _then(_WorkoutPlanDbModel(
workoutPlanId: freezed == workoutPlanId ? _self.workoutPlanId : workoutPlanId // ignore: cast_nullable_to_non_nullable
as int?,workoutPlanName: null == workoutPlanName ? _self.workoutPlanName : workoutPlanName // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
