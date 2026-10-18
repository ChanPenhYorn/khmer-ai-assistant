// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TranslationState {

/// Source language. [AiLanguage.auto] detects from the Khmer script.
 AiLanguage get source;/// Language the text is translated into.
 AiLanguage get target; String get input; String get output; GenerationStatus get status; AppFailure? get failure;/// Language reported by the backend, when it reports one. The app does not
/// invent a detection result.
 String? get detectedLanguageCode;
/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationStateCopyWith<TranslationState> get copyWith => _$TranslationStateCopyWithImpl<TranslationState>(this as TranslationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranslationState&&(identical(other.source, source) || other.source == source)&&(identical(other.target, target) || other.target == target)&&(identical(other.input, input) || other.input == input)&&(identical(other.output, output) || other.output == output)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.detectedLanguageCode, detectedLanguageCode) || other.detectedLanguageCode == detectedLanguageCode));
}


@override
int get hashCode => Object.hash(runtimeType,source,target,input,output,status,failure,detectedLanguageCode);

@override
String toString() {
  return 'TranslationState(source: $source, target: $target, input: $input, output: $output, status: $status, failure: $failure, detectedLanguageCode: $detectedLanguageCode)';
}


}

/// @nodoc
abstract mixin class $TranslationStateCopyWith<$Res>  {
  factory $TranslationStateCopyWith(TranslationState value, $Res Function(TranslationState) _then) = _$TranslationStateCopyWithImpl;
@useResult
$Res call({
 AiLanguage source, AiLanguage target, String input, String output, GenerationStatus status, AppFailure? failure, String? detectedLanguageCode
});




}
/// @nodoc
class _$TranslationStateCopyWithImpl<$Res>
    implements $TranslationStateCopyWith<$Res> {
  _$TranslationStateCopyWithImpl(this._self, this._then);

  final TranslationState _self;
  final $Res Function(TranslationState) _then;

/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? target = null,Object? input = null,Object? output = null,Object? status = null,Object? failure = freezed,Object? detectedLanguageCode = freezed,}) {
  return _then(_self.copyWith(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AiLanguage,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as AiLanguage,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GenerationStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,detectedLanguageCode: freezed == detectedLanguageCode ? _self.detectedLanguageCode : detectedLanguageCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TranslationState].
extension TranslationStatePatterns on TranslationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranslationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranslationState value)  $default,){
final _that = this;
switch (_that) {
case _TranslationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranslationState value)?  $default,){
final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiLanguage source,  AiLanguage target,  String input,  String output,  GenerationStatus status,  AppFailure? failure,  String? detectedLanguageCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
return $default(_that.source,_that.target,_that.input,_that.output,_that.status,_that.failure,_that.detectedLanguageCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiLanguage source,  AiLanguage target,  String input,  String output,  GenerationStatus status,  AppFailure? failure,  String? detectedLanguageCode)  $default,) {final _that = this;
switch (_that) {
case _TranslationState():
return $default(_that.source,_that.target,_that.input,_that.output,_that.status,_that.failure,_that.detectedLanguageCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiLanguage source,  AiLanguage target,  String input,  String output,  GenerationStatus status,  AppFailure? failure,  String? detectedLanguageCode)?  $default,) {final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
return $default(_that.source,_that.target,_that.input,_that.output,_that.status,_that.failure,_that.detectedLanguageCode);case _:
  return null;

}
}

}

/// @nodoc


class _TranslationState extends TranslationState {
  const _TranslationState({this.source = AiLanguage.auto, this.target = AiLanguage.khmer, this.input = '', this.output = '', this.status = GenerationStatus.idle, this.failure, this.detectedLanguageCode}): super._();
  

/// Source language. [AiLanguage.auto] detects from the Khmer script.
@override@JsonKey() final  AiLanguage source;
/// Language the text is translated into.
@override@JsonKey() final  AiLanguage target;
@override@JsonKey() final  String input;
@override@JsonKey() final  String output;
@override@JsonKey() final  GenerationStatus status;
@override final  AppFailure? failure;
/// Language reported by the backend, when it reports one. The app does not
/// invent a detection result.
@override final  String? detectedLanguageCode;

/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationStateCopyWith<_TranslationState> get copyWith => __$TranslationStateCopyWithImpl<_TranslationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranslationState&&(identical(other.source, source) || other.source == source)&&(identical(other.target, target) || other.target == target)&&(identical(other.input, input) || other.input == input)&&(identical(other.output, output) || other.output == output)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.detectedLanguageCode, detectedLanguageCode) || other.detectedLanguageCode == detectedLanguageCode));
}


@override
int get hashCode => Object.hash(runtimeType,source,target,input,output,status,failure,detectedLanguageCode);

@override
String toString() {
  return 'TranslationState(source: $source, target: $target, input: $input, output: $output, status: $status, failure: $failure, detectedLanguageCode: $detectedLanguageCode)';
}


}

/// @nodoc
abstract mixin class _$TranslationStateCopyWith<$Res> implements $TranslationStateCopyWith<$Res> {
  factory _$TranslationStateCopyWith(_TranslationState value, $Res Function(_TranslationState) _then) = __$TranslationStateCopyWithImpl;
@override @useResult
$Res call({
 AiLanguage source, AiLanguage target, String input, String output, GenerationStatus status, AppFailure? failure, String? detectedLanguageCode
});




}
/// @nodoc
class __$TranslationStateCopyWithImpl<$Res>
    implements _$TranslationStateCopyWith<$Res> {
  __$TranslationStateCopyWithImpl(this._self, this._then);

  final _TranslationState _self;
  final $Res Function(_TranslationState) _then;

/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? target = null,Object? input = null,Object? output = null,Object? status = null,Object? failure = freezed,Object? detectedLanguageCode = freezed,}) {
  return _then(_TranslationState(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as AiLanguage,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as AiLanguage,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GenerationStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure?,detectedLanguageCode: freezed == detectedLanguageCode ? _self.detectedLanguageCode : detectedLanguageCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
