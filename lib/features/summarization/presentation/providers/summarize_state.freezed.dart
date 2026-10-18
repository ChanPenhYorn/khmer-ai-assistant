// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'summarize_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SummarizeState {

 SummaryStyle get style; AiLanguage get outputLanguage; String get input; String get output; GenerationStatus get status; AppFailure? get failure;
/// Create a copy of SummarizeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SummarizeStateCopyWith<SummarizeState> get copyWith => _$SummarizeStateCopyWithImpl<SummarizeState>(this as SummarizeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SummarizeState&&(identical(other.style, style) || other.style == style)&&(identical(other.outputLanguage, outputLanguage) || other.outputLanguage == outputLanguage)&&(identical(other.input, input) || other.input == input)&&(identical(other.output, output) || other.output == output)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,style,outputLanguage,input,output,status,failure);

@override
String toString() {
  return 'SummarizeState(style: $style, outputLanguage: $outputLanguage, input: $input, output: $output, status: $status, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SummarizeStateCopyWith<$Res>  {
  factory $SummarizeStateCopyWith(SummarizeState value, $Res Function(SummarizeState) _then) = _$SummarizeStateCopyWithImpl;
@useResult
$Res call({
 SummaryStyle style, AiLanguage outputLanguage, String input, String output, GenerationStatus status, AppFailure? failure
});




}
/// @nodoc
class _$SummarizeStateCopyWithImpl<$Res>
    implements $SummarizeStateCopyWith<$Res> {
  _$SummarizeStateCopyWithImpl(this._self, this._then);

  final SummarizeState _self;
  final $Res Function(SummarizeState) _then;

/// Create a copy of SummarizeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? style = null,Object? outputLanguage = null,Object? input = null,Object? output = null,Object? status = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as SummaryStyle,outputLanguage: null == outputLanguage ? _self.outputLanguage : outputLanguage // ignore: cast_nullable_to_non_nullable
as AiLanguage,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GenerationStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [SummarizeState].
extension SummarizeStatePatterns on SummarizeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SummarizeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SummarizeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SummarizeState value)  $default,){
final _that = this;
switch (_that) {
case _SummarizeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SummarizeState value)?  $default,){
final _that = this;
switch (_that) {
case _SummarizeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SummaryStyle style,  AiLanguage outputLanguage,  String input,  String output,  GenerationStatus status,  AppFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SummarizeState() when $default != null:
return $default(_that.style,_that.outputLanguage,_that.input,_that.output,_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SummaryStyle style,  AiLanguage outputLanguage,  String input,  String output,  GenerationStatus status,  AppFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _SummarizeState():
return $default(_that.style,_that.outputLanguage,_that.input,_that.output,_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SummaryStyle style,  AiLanguage outputLanguage,  String input,  String output,  GenerationStatus status,  AppFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _SummarizeState() when $default != null:
return $default(_that.style,_that.outputLanguage,_that.input,_that.output,_that.status,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _SummarizeState extends SummarizeState {
  const _SummarizeState({this.style = SummaryStyle.bullets, this.outputLanguage = AiLanguage.khmer, this.input = '', this.output = '', this.status = GenerationStatus.idle, this.failure}): super._();
  

@override@JsonKey() final  SummaryStyle style;
@override@JsonKey() final  AiLanguage outputLanguage;
@override@JsonKey() final  String input;
@override@JsonKey() final  String output;
@override@JsonKey() final  GenerationStatus status;
@override final  AppFailure? failure;

/// Create a copy of SummarizeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SummarizeStateCopyWith<_SummarizeState> get copyWith => __$SummarizeStateCopyWithImpl<_SummarizeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SummarizeState&&(identical(other.style, style) || other.style == style)&&(identical(other.outputLanguage, outputLanguage) || other.outputLanguage == outputLanguage)&&(identical(other.input, input) || other.input == input)&&(identical(other.output, output) || other.output == output)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,style,outputLanguage,input,output,status,failure);

@override
String toString() {
  return 'SummarizeState(style: $style, outputLanguage: $outputLanguage, input: $input, output: $output, status: $status, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$SummarizeStateCopyWith<$Res> implements $SummarizeStateCopyWith<$Res> {
  factory _$SummarizeStateCopyWith(_SummarizeState value, $Res Function(_SummarizeState) _then) = __$SummarizeStateCopyWithImpl;
@override @useResult
$Res call({
 SummaryStyle style, AiLanguage outputLanguage, String input, String output, GenerationStatus status, AppFailure? failure
});




}
/// @nodoc
class __$SummarizeStateCopyWithImpl<$Res>
    implements _$SummarizeStateCopyWith<$Res> {
  __$SummarizeStateCopyWithImpl(this._self, this._then);

  final _SummarizeState _self;
  final $Res Function(_SummarizeState) _then;

/// Create a copy of SummarizeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? style = null,Object? outputLanguage = null,Object? input = null,Object? output = null,Object? status = null,Object? failure = freezed,}) {
  return _then(_SummarizeState(
style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as SummaryStyle,outputLanguage: null == outputLanguage ? _self.outputLanguage : outputLanguage // ignore: cast_nullable_to_non_nullable
as AiLanguage,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GenerationStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}


}

// dart format on
