// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Invoice implements DiagnosticableTreeMixin {

 int? get id; int? get customerId; String get customerName; String get customerEmail; String get customerPhone; String get invoiceNumber; DateTime get dateIssued; DateTime get dueDate; List<InvoiceItem> get items; double get totalAmount; String get status;
/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceCopyWith<Invoice> get copyWith => _$InvoiceCopyWithImpl<Invoice>(this as Invoice, _$identity);

  /// Serializes this Invoice to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Invoice'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('customerId', customerId))..add(DiagnosticsProperty('customerName', customerName))..add(DiagnosticsProperty('customerEmail', customerEmail))..add(DiagnosticsProperty('customerPhone', customerPhone))..add(DiagnosticsProperty('invoiceNumber', invoiceNumber))..add(DiagnosticsProperty('dateIssued', dateIssued))..add(DiagnosticsProperty('dueDate', dueDate))..add(DiagnosticsProperty('items', items))..add(DiagnosticsProperty('totalAmount', totalAmount))..add(DiagnosticsProperty('status', status));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerEmail, customerEmail) || other.customerEmail == customerEmail)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.dateIssued, dateIssued) || other.dateIssued == dateIssued)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,customerName,customerEmail,customerPhone,invoiceNumber,dateIssued,dueDate,const DeepCollectionEquality().hash(items),totalAmount,status);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Invoice(id: $id, customerId: $customerId, customerName: $customerName, customerEmail: $customerEmail, customerPhone: $customerPhone, invoiceNumber: $invoiceNumber, dateIssued: $dateIssued, dueDate: $dueDate, items: $items, totalAmount: $totalAmount, status: $status)';
}


}

/// @nodoc
abstract mixin class $InvoiceCopyWith<$Res>  {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) _then) = _$InvoiceCopyWithImpl;
@useResult
$Res call({
 int? id, int? customerId, String customerName, String customerEmail, String customerPhone, String invoiceNumber, DateTime dateIssued, DateTime dueDate, List<InvoiceItem> items, double totalAmount, String status
});




}
/// @nodoc
class _$InvoiceCopyWithImpl<$Res>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._self, this._then);

  final Invoice _self;
  final $Res Function(Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? customerId = freezed,Object? customerName = null,Object? customerEmail = null,Object? customerPhone = null,Object? invoiceNumber = null,Object? dateIssued = null,Object? dueDate = null,Object? items = null,Object? totalAmount = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,customerEmail: null == customerEmail ? _self.customerEmail : customerEmail // ignore: cast_nullable_to_non_nullable
as String,customerPhone: null == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,dateIssued: null == dateIssued ? _self.dateIssued : dateIssued // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<InvoiceItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Invoice].
extension InvoicePatterns on Invoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Invoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Invoice value)  $default,){
final _that = this;
switch (_that) {
case _Invoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Invoice value)?  $default,){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? customerId,  String customerName,  String customerEmail,  String customerPhone,  String invoiceNumber,  DateTime dateIssued,  DateTime dueDate,  List<InvoiceItem> items,  double totalAmount,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.customerId,_that.customerName,_that.customerEmail,_that.customerPhone,_that.invoiceNumber,_that.dateIssued,_that.dueDate,_that.items,_that.totalAmount,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? customerId,  String customerName,  String customerEmail,  String customerPhone,  String invoiceNumber,  DateTime dateIssued,  DateTime dueDate,  List<InvoiceItem> items,  double totalAmount,  String status)  $default,) {final _that = this;
switch (_that) {
case _Invoice():
return $default(_that.id,_that.customerId,_that.customerName,_that.customerEmail,_that.customerPhone,_that.invoiceNumber,_that.dateIssued,_that.dueDate,_that.items,_that.totalAmount,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? customerId,  String customerName,  String customerEmail,  String customerPhone,  String invoiceNumber,  DateTime dateIssued,  DateTime dueDate,  List<InvoiceItem> items,  double totalAmount,  String status)?  $default,) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.customerId,_that.customerName,_that.customerEmail,_that.customerPhone,_that.invoiceNumber,_that.dateIssued,_that.dueDate,_that.items,_that.totalAmount,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Invoice with DiagnosticableTreeMixin implements Invoice {
  const _Invoice({this.id, this.customerId, required this.customerName, required this.customerEmail, required this.customerPhone, required this.invoiceNumber, required this.dateIssued, required this.dueDate, required final  List<InvoiceItem> items, required this.totalAmount, this.status = 'Pending'}): _items = items;
  factory _Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

@override final  int? id;
@override final  int? customerId;
@override final  String customerName;
@override final  String customerEmail;
@override final  String customerPhone;
@override final  String invoiceNumber;
@override final  DateTime dateIssued;
@override final  DateTime dueDate;
 final  List<InvoiceItem> _items;
@override List<InvoiceItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  double totalAmount;
@override@JsonKey() final  String status;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceCopyWith<_Invoice> get copyWith => __$InvoiceCopyWithImpl<_Invoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Invoice'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('customerId', customerId))..add(DiagnosticsProperty('customerName', customerName))..add(DiagnosticsProperty('customerEmail', customerEmail))..add(DiagnosticsProperty('customerPhone', customerPhone))..add(DiagnosticsProperty('invoiceNumber', invoiceNumber))..add(DiagnosticsProperty('dateIssued', dateIssued))..add(DiagnosticsProperty('dueDate', dueDate))..add(DiagnosticsProperty('items', items))..add(DiagnosticsProperty('totalAmount', totalAmount))..add(DiagnosticsProperty('status', status));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerEmail, customerEmail) || other.customerEmail == customerEmail)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.dateIssued, dateIssued) || other.dateIssued == dateIssued)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,customerName,customerEmail,customerPhone,invoiceNumber,dateIssued,dueDate,const DeepCollectionEquality().hash(_items),totalAmount,status);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Invoice(id: $id, customerId: $customerId, customerName: $customerName, customerEmail: $customerEmail, customerPhone: $customerPhone, invoiceNumber: $invoiceNumber, dateIssued: $dateIssued, dueDate: $dueDate, items: $items, totalAmount: $totalAmount, status: $status)';
}


}

/// @nodoc
abstract mixin class _$InvoiceCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$InvoiceCopyWith(_Invoice value, $Res Function(_Invoice) _then) = __$InvoiceCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? customerId, String customerName, String customerEmail, String customerPhone, String invoiceNumber, DateTime dateIssued, DateTime dueDate, List<InvoiceItem> items, double totalAmount, String status
});




}
/// @nodoc
class __$InvoiceCopyWithImpl<$Res>
    implements _$InvoiceCopyWith<$Res> {
  __$InvoiceCopyWithImpl(this._self, this._then);

  final _Invoice _self;
  final $Res Function(_Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? customerId = freezed,Object? customerName = null,Object? customerEmail = null,Object? customerPhone = null,Object? invoiceNumber = null,Object? dateIssued = null,Object? dueDate = null,Object? items = null,Object? totalAmount = null,Object? status = null,}) {
  return _then(_Invoice(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as int?,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,customerEmail: null == customerEmail ? _self.customerEmail : customerEmail // ignore: cast_nullable_to_non_nullable
as String,customerPhone: null == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,dateIssued: null == dateIssued ? _self.dateIssued : dateIssued // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<InvoiceItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$InvoiceItem implements DiagnosticableTreeMixin {

 String get description; int get quantity; int get unitPriceKobo;
/// Create a copy of InvoiceItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceItemCopyWith<InvoiceItem> get copyWith => _$InvoiceItemCopyWithImpl<InvoiceItem>(this as InvoiceItem, _$identity);

  /// Serializes this InvoiceItem to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InvoiceItem'))
    ..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('quantity', quantity))..add(DiagnosticsProperty('unitPriceKobo', unitPriceKobo));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceItem&&(identical(other.description, description) || other.description == description)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPriceKobo, unitPriceKobo) || other.unitPriceKobo == unitPriceKobo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,description,quantity,unitPriceKobo);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InvoiceItem(description: $description, quantity: $quantity, unitPriceKobo: $unitPriceKobo)';
}


}

/// @nodoc
abstract mixin class $InvoiceItemCopyWith<$Res>  {
  factory $InvoiceItemCopyWith(InvoiceItem value, $Res Function(InvoiceItem) _then) = _$InvoiceItemCopyWithImpl;
@useResult
$Res call({
 String description, int quantity, int unitPriceKobo
});




}
/// @nodoc
class _$InvoiceItemCopyWithImpl<$Res>
    implements $InvoiceItemCopyWith<$Res> {
  _$InvoiceItemCopyWithImpl(this._self, this._then);

  final InvoiceItem _self;
  final $Res Function(InvoiceItem) _then;

/// Create a copy of InvoiceItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? description = null,Object? quantity = null,Object? unitPriceKobo = null,}) {
  return _then(_self.copyWith(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPriceKobo: null == unitPriceKobo ? _self.unitPriceKobo : unitPriceKobo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoiceItem].
extension InvoiceItemPatterns on InvoiceItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoiceItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoiceItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoiceItem value)  $default,){
final _that = this;
switch (_that) {
case _InvoiceItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoiceItem value)?  $default,){
final _that = this;
switch (_that) {
case _InvoiceItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String description,  int quantity,  int unitPriceKobo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoiceItem() when $default != null:
return $default(_that.description,_that.quantity,_that.unitPriceKobo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String description,  int quantity,  int unitPriceKobo)  $default,) {final _that = this;
switch (_that) {
case _InvoiceItem():
return $default(_that.description,_that.quantity,_that.unitPriceKobo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String description,  int quantity,  int unitPriceKobo)?  $default,) {final _that = this;
switch (_that) {
case _InvoiceItem() when $default != null:
return $default(_that.description,_that.quantity,_that.unitPriceKobo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvoiceItem with DiagnosticableTreeMixin implements InvoiceItem {
  const _InvoiceItem({required this.description, required this.quantity, required this.unitPriceKobo});
  factory _InvoiceItem.fromJson(Map<String, dynamic> json) => _$InvoiceItemFromJson(json);

@override final  String description;
@override final  int quantity;
@override final  int unitPriceKobo;

/// Create a copy of InvoiceItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceItemCopyWith<_InvoiceItem> get copyWith => __$InvoiceItemCopyWithImpl<_InvoiceItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceItemToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InvoiceItem'))
    ..add(DiagnosticsProperty('description', description))..add(DiagnosticsProperty('quantity', quantity))..add(DiagnosticsProperty('unitPriceKobo', unitPriceKobo));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceItem&&(identical(other.description, description) || other.description == description)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPriceKobo, unitPriceKobo) || other.unitPriceKobo == unitPriceKobo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,description,quantity,unitPriceKobo);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InvoiceItem(description: $description, quantity: $quantity, unitPriceKobo: $unitPriceKobo)';
}


}

/// @nodoc
abstract mixin class _$InvoiceItemCopyWith<$Res> implements $InvoiceItemCopyWith<$Res> {
  factory _$InvoiceItemCopyWith(_InvoiceItem value, $Res Function(_InvoiceItem) _then) = __$InvoiceItemCopyWithImpl;
@override @useResult
$Res call({
 String description, int quantity, int unitPriceKobo
});




}
/// @nodoc
class __$InvoiceItemCopyWithImpl<$Res>
    implements _$InvoiceItemCopyWith<$Res> {
  __$InvoiceItemCopyWithImpl(this._self, this._then);

  final _InvoiceItem _self;
  final $Res Function(_InvoiceItem) _then;

/// Create a copy of InvoiceItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? description = null,Object? quantity = null,Object? unitPriceKobo = null,}) {
  return _then(_InvoiceItem(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPriceKobo: null == unitPriceKobo ? _self.unitPriceKobo : unitPriceKobo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
