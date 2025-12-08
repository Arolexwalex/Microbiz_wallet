// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoanApplication {

 String get id; String get businessName; double get amountRequested; String get purpose; String get status; DateTime get appliedAt; String? get lenderName; String? get rejectionReason; DateTime? get approvedAt; DateTime? get disbursedAt;
/// Create a copy of LoanApplication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanApplicationCopyWith<LoanApplication> get copyWith => _$LoanApplicationCopyWithImpl<LoanApplication>(this as LoanApplication, _$identity);

  /// Serializes this LoanApplication to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.amountRequested, amountRequested) || other.amountRequested == amountRequested)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.status, status) || other.status == status)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt)&&(identical(other.lenderName, lenderName) || other.lenderName == lenderName)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.disbursedAt, disbursedAt) || other.disbursedAt == disbursedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessName,amountRequested,purpose,status,appliedAt,lenderName,rejectionReason,approvedAt,disbursedAt);

@override
String toString() {
  return 'LoanApplication(id: $id, businessName: $businessName, amountRequested: $amountRequested, purpose: $purpose, status: $status, appliedAt: $appliedAt, lenderName: $lenderName, rejectionReason: $rejectionReason, approvedAt: $approvedAt, disbursedAt: $disbursedAt)';
}


}

/// @nodoc
abstract mixin class $LoanApplicationCopyWith<$Res>  {
  factory $LoanApplicationCopyWith(LoanApplication value, $Res Function(LoanApplication) _then) = _$LoanApplicationCopyWithImpl;
@useResult
$Res call({
 String id, String businessName, double amountRequested, String purpose, String status, DateTime appliedAt, String? lenderName, String? rejectionReason, DateTime? approvedAt, DateTime? disbursedAt
});




}
/// @nodoc
class _$LoanApplicationCopyWithImpl<$Res>
    implements $LoanApplicationCopyWith<$Res> {
  _$LoanApplicationCopyWithImpl(this._self, this._then);

  final LoanApplication _self;
  final $Res Function(LoanApplication) _then;

/// Create a copy of LoanApplication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessName = null,Object? amountRequested = null,Object? purpose = null,Object? status = null,Object? appliedAt = null,Object? lenderName = freezed,Object? rejectionReason = freezed,Object? approvedAt = freezed,Object? disbursedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,amountRequested: null == amountRequested ? _self.amountRequested : amountRequested // ignore: cast_nullable_to_non_nullable
as double,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,appliedAt: null == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lenderName: freezed == lenderName ? _self.lenderName : lenderName // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,disbursedAt: freezed == disbursedAt ? _self.disbursedAt : disbursedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanApplication].
extension LoanApplicationPatterns on LoanApplication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanApplication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanApplication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanApplication value)  $default,){
final _that = this;
switch (_that) {
case _LoanApplication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanApplication value)?  $default,){
final _that = this;
switch (_that) {
case _LoanApplication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String businessName,  double amountRequested,  String purpose,  String status,  DateTime appliedAt,  String? lenderName,  String? rejectionReason,  DateTime? approvedAt,  DateTime? disbursedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanApplication() when $default != null:
return $default(_that.id,_that.businessName,_that.amountRequested,_that.purpose,_that.status,_that.appliedAt,_that.lenderName,_that.rejectionReason,_that.approvedAt,_that.disbursedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String businessName,  double amountRequested,  String purpose,  String status,  DateTime appliedAt,  String? lenderName,  String? rejectionReason,  DateTime? approvedAt,  DateTime? disbursedAt)  $default,) {final _that = this;
switch (_that) {
case _LoanApplication():
return $default(_that.id,_that.businessName,_that.amountRequested,_that.purpose,_that.status,_that.appliedAt,_that.lenderName,_that.rejectionReason,_that.approvedAt,_that.disbursedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String businessName,  double amountRequested,  String purpose,  String status,  DateTime appliedAt,  String? lenderName,  String? rejectionReason,  DateTime? approvedAt,  DateTime? disbursedAt)?  $default,) {final _that = this;
switch (_that) {
case _LoanApplication() when $default != null:
return $default(_that.id,_that.businessName,_that.amountRequested,_that.purpose,_that.status,_that.appliedAt,_that.lenderName,_that.rejectionReason,_that.approvedAt,_that.disbursedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoanApplication implements LoanApplication {
  const _LoanApplication({required this.id, required this.businessName, required this.amountRequested, required this.purpose, required this.status, required this.appliedAt, this.lenderName, this.rejectionReason, this.approvedAt, this.disbursedAt});
  factory _LoanApplication.fromJson(Map<String, dynamic> json) => _$LoanApplicationFromJson(json);

@override final  String id;
@override final  String businessName;
@override final  double amountRequested;
@override final  String purpose;
@override final  String status;
@override final  DateTime appliedAt;
@override final  String? lenderName;
@override final  String? rejectionReason;
@override final  DateTime? approvedAt;
@override final  DateTime? disbursedAt;

/// Create a copy of LoanApplication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanApplicationCopyWith<_LoanApplication> get copyWith => __$LoanApplicationCopyWithImpl<_LoanApplication>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanApplicationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.amountRequested, amountRequested) || other.amountRequested == amountRequested)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.status, status) || other.status == status)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt)&&(identical(other.lenderName, lenderName) || other.lenderName == lenderName)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.disbursedAt, disbursedAt) || other.disbursedAt == disbursedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessName,amountRequested,purpose,status,appliedAt,lenderName,rejectionReason,approvedAt,disbursedAt);

@override
String toString() {
  return 'LoanApplication(id: $id, businessName: $businessName, amountRequested: $amountRequested, purpose: $purpose, status: $status, appliedAt: $appliedAt, lenderName: $lenderName, rejectionReason: $rejectionReason, approvedAt: $approvedAt, disbursedAt: $disbursedAt)';
}


}

/// @nodoc
abstract mixin class _$LoanApplicationCopyWith<$Res> implements $LoanApplicationCopyWith<$Res> {
  factory _$LoanApplicationCopyWith(_LoanApplication value, $Res Function(_LoanApplication) _then) = __$LoanApplicationCopyWithImpl;
@override @useResult
$Res call({
 String id, String businessName, double amountRequested, String purpose, String status, DateTime appliedAt, String? lenderName, String? rejectionReason, DateTime? approvedAt, DateTime? disbursedAt
});




}
/// @nodoc
class __$LoanApplicationCopyWithImpl<$Res>
    implements _$LoanApplicationCopyWith<$Res> {
  __$LoanApplicationCopyWithImpl(this._self, this._then);

  final _LoanApplication _self;
  final $Res Function(_LoanApplication) _then;

/// Create a copy of LoanApplication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessName = null,Object? amountRequested = null,Object? purpose = null,Object? status = null,Object? appliedAt = null,Object? lenderName = freezed,Object? rejectionReason = freezed,Object? approvedAt = freezed,Object? disbursedAt = freezed,}) {
  return _then(_LoanApplication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,amountRequested: null == amountRequested ? _self.amountRequested : amountRequested // ignore: cast_nullable_to_non_nullable
as double,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,appliedAt: null == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lenderName: freezed == lenderName ? _self.lenderName : lenderName // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,disbursedAt: freezed == disbursedAt ? _self.disbursedAt : disbursedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
