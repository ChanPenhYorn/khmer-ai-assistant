// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'writing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WritingState {

 WritingAction get action; WritingTone get tone; AiLanguage get targetLanguage; String get input; String get output; GenerationStatus get status; AppFailure? get failure;
/// Create a copy of WritingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WritingStateCopyWith<WritingState> get copyWith => _$WritingStateCopyWithImpl<WritingState>(this as WritingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WritingState&&(identical(other.action, action) || other.action == action)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.targetLanguage, targetLanguage) || other.targetLanguage == targetLanguage)&&(identical(other.input, input) || other.input == input)&&(identical(other.output, output) || other.output == output)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,action,tone,targetLanguage,input,output,status,failure);

@override
String toString() {
  return 'WritingState(action: $action, tone: $tone, targetLanguage: $targetLanguage, input: $input, output: $output, status: $status, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $WritingStateCopyWith<$Res>  {
  factory $WritingStateCopyWith(WritingState value, $Res Function(WritingState) _then) = _$WritingStateCopyWithImpl;
@useResult
$Res call({
 WritingAction action, WritingTone tone, AiLanguage targetLanguage, String input, String output, GenerationStatus status, AppFailure? failure
});




}
/// @nodoc
class _$WritingStateCopyWithImpl<$Res>
    implements $WritingStateCopyWith<$Res> {
  _$WritingStateCopyWithImpl(this._self, this._then);

  final WritingState _self;
  final $Res Function(WritingState) _then;

/// Create a copy of WritingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? tone = null,Object? targetLanguage = null,Object? input = null,Object? output = null,Object? status = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as WritingAction,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as WritingTone,targetLanguage: null == targetLanguage ? _self.targetLanguage : targetLanguage // ignore: cast_nullable_to_non_nullable
as AiLanguage,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GenerationStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [WritingState].
extension WritingStatePatterns on WritingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WritingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WritingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WritingState value)  $default,){
final _that = this;
switch (_that) {
case _WritingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WritingState value)?  $default,){
final _that = this;
switch (_that) {
case _WritingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WritingAction action,  WritingTone tone,  AiLanguage targetLanguage,  String input,  String output,  GenerationStatus status,  AppFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WritingState() when $default != null:
return $default(_that.action,_that.tone,_that.targetLanguage,_that.input,_that.output,_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WritingAction action,  WritingTone tone,  AiLanguage targetLanguage,  String input,  String output,  GenerationStatus status,  AppFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _WritingState():
return $default(_that.action,_that.tone,_that.targetLanguage,_that.input,_that.output,_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WritingAction action,  WritingTone tone,  AiLanguage targetLanguage,  String input,  String output,  GenerationStatus status,  AppFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _WritingState() when $default != null:
return $default(_that.action,_that.tone,_that.targetLanguage,_that.input,_that.output,_that.status,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _WritingState extends WritingState {
  const _WritingState({this.action = WritingAction.improve, this.tone = WritingTone.neutral, this.targetLanguage = AiLanguage.khmer, this.input = '', this.output = '', this.status = GenerationStatus.idle, this.failure}): super._();
  

@override@JsonKey() final  WritingAction action;
@override@JsonKey() final  WritingTone tone;
@override@JsonKey() final  AiLanguage targetLanguage;
@override@JsonKey() final  String input;
@override@JsonKey() final  String output;
@override@JsonKey() final  GenerationStatus status;
@override final  AppFailure? failure;

/// Create a copy of WritingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WritingStateCopyWith<_WritingState> get copyWith => __$WritingStateCopyWithImpl<_WritingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WritingState&&(identical(other.action, action) || other.action == action)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.targetLanguage, targetLanguage) || other.targetLanguage == targetLanguage)&&(identical(other.input, input) || other.input == input)&&(identical(other.output, output) || other.output == output)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,action,tone,targetLanguage,input,output,status,failure);

@override
String toString() {
  return 'WritingState(action: $action, tone: $tone, targetLanguage: $targetLanguage, input: $input, output: $output, status: $status, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$WritingStateCopyWith<$Res> implements $WritingStateCopyWith<$Res> {
  factory _$WritingStateCopyWith(_WritingState value, $Res Function(_WritingState) _then) = __$WritingStateCopyWithImpl;
@override @useResult
$Res call({
 WritingAction action, WritingTone tone, AiLanguage targetLanguage, String input, String output, GenerationStatus status, AppFailure? failure
});




}
/// @nodoc
class __$WritingStateCopyWithImpl<$Res>
    implements _$WritingStateCopyWith<$Res> {
  __$WritingStateCopyWithImpl(this._self, this._then);

  final _WritingState _self;
  final $Res Function(_WritingState) _then;

/// Create a copy of WritingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? tone = null,Object? targetLanguage = null,Object? input = null,Object? output = null,Object? status = null,Object? failure = freezed,}) {
  return _then(_WritingState(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as WritingAction,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as WritingTone,targetLanguage: null == targetLanguage ? _self.targetLanguage : targetLanguage // ignore: cast_nullable_to_non_nullable
as AiLanguage,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GenerationStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}


}

// dart format on
