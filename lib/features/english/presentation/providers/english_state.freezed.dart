// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'english_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EnglishState {

 AiLanguage get explanationLanguage; String get input; String get output; GenerationStatus get status; AppFailure? get failure;
/// Create a copy of EnglishState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnglishStateCopyWith<EnglishState> get copyWith => _$EnglishStateCopyWithImpl<EnglishState>(this as EnglishState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnglishState&&(identical(other.explanationLanguage, explanationLanguage) || other.explanationLanguage == explanationLanguage)&&(identical(other.input, input) || other.input == input)&&(identical(other.output, output) || other.output == output)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,explanationLanguage,input,output,status,failure);

@override
String toString() {
  return 'EnglishState(explanationLanguage: $explanationLanguage, input: $input, output: $output, status: $status, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $EnglishStateCopyWith<$Res>  {
  factory $EnglishStateCopyWith(EnglishState value, $Res Function(EnglishState) _then) = _$EnglishStateCopyWithImpl;
@useResult
$Res call({
 AiLanguage explanationLanguage, String input, String output, GenerationStatus status, AppFailure? failure
});




}
/// @nodoc
class _$EnglishStateCopyWithImpl<$Res>
    implements $EnglishStateCopyWith<$Res> {
  _$EnglishStateCopyWithImpl(this._self, this._then);

  final EnglishState _self;
  final $Res Function(EnglishState) _then;

/// Create a copy of EnglishState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? explanationLanguage = null,Object? input = null,Object? output = null,Object? status = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
explanationLanguage: null == explanationLanguage ? _self.explanationLanguage : explanationLanguage // ignore: cast_nullable_to_non_nullable
as AiLanguage,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GenerationStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [EnglishState].
extension EnglishStatePatterns on EnglishState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnglishState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnglishState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnglishState value)  $default,){
final _that = this;
switch (_that) {
case _EnglishState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnglishState value)?  $default,){
final _that = this;
switch (_that) {
case _EnglishState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiLanguage explanationLanguage,  String input,  String output,  GenerationStatus status,  AppFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnglishState() when $default != null:
return $default(_that.explanationLanguage,_that.input,_that.output,_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiLanguage explanationLanguage,  String input,  String output,  GenerationStatus status,  AppFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _EnglishState():
return $default(_that.explanationLanguage,_that.input,_that.output,_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiLanguage explanationLanguage,  String input,  String output,  GenerationStatus status,  AppFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _EnglishState() when $default != null:
return $default(_that.explanationLanguage,_that.input,_that.output,_that.status,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _EnglishState extends EnglishState {
  const _EnglishState({this.explanationLanguage = AiLanguage.khmer, this.input = '', this.output = '', this.status = GenerationStatus.idle, this.failure}): super._();
  

@override@JsonKey() final  AiLanguage explanationLanguage;
@override@JsonKey() final  String input;
@override@JsonKey() final  String output;
@override@JsonKey() final  GenerationStatus status;
@override final  AppFailure? failure;

/// Create a copy of EnglishState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnglishStateCopyWith<_EnglishState> get copyWith => __$EnglishStateCopyWithImpl<_EnglishState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnglishState&&(identical(other.explanationLanguage, explanationLanguage) || other.explanationLanguage == explanationLanguage)&&(identical(other.input, input) || other.input == input)&&(identical(other.output, output) || other.output == output)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,explanationLanguage,input,output,status,failure);

@override
String toString() {
  return 'EnglishState(explanationLanguage: $explanationLanguage, input: $input, output: $output, status: $status, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$EnglishStateCopyWith<$Res> implements $EnglishStateCopyWith<$Res> {
  factory _$EnglishStateCopyWith(_EnglishState value, $Res Function(_EnglishState) _then) = __$EnglishStateCopyWithImpl;
@override @useResult
$Res call({
 AiLanguage explanationLanguage, String input, String output, GenerationStatus status, AppFailure? failure
});




}
/// @nodoc
class __$EnglishStateCopyWithImpl<$Res>
    implements _$EnglishStateCopyWith<$Res> {
  __$EnglishStateCopyWithImpl(this._self, this._then);

  final _EnglishState _self;
  final $Res Function(_EnglishState) _then;

/// Create a copy of EnglishState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? explanationLanguage = null,Object? input = null,Object? output = null,Object? status = null,Object? failure = freezed,}) {
  return _then(_EnglishState(
explanationLanguage: null == explanationLanguage ? _self.explanationLanguage : explanationLanguage // ignore: cast_nullable_to_non_nullable
as AiLanguage,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GenerationStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}


}

// dart format on
