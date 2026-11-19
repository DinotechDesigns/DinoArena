// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Booking {

 String get id; String get code; BookingKind get kind; String get title; String get venue; SportType get sport; DateTime get start; DateTime get end; int get amountPaid; BookingStatus get status; DateTime get createdAt; String? get referenceId; String? get unitLabel; String? get paymentId; List<String> get slotLabels; int get players;
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCopyWith<Booking> get copyWith => _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.unitLabel, unitLabel) || other.unitLabel == unitLabel)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&const DeepCollectionEquality().equals(other.slotLabels, slotLabels)&&(identical(other.players, players) || other.players == players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,kind,title,venue,sport,start,end,amountPaid,status,createdAt,referenceId,unitLabel,paymentId,const DeepCollectionEquality().hash(slotLabels),players);

@override
String toString() {
  return 'Booking(id: $id, code: $code, kind: $kind, title: $title, venue: $venue, sport: $sport, start: $start, end: $end, amountPaid: $amountPaid, status: $status, createdAt: $createdAt, referenceId: $referenceId, unitLabel: $unitLabel, paymentId: $paymentId, slotLabels: $slotLabels, players: $players)';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
 String id, String code, BookingKind kind, String title, String venue, SportType sport, DateTime start, DateTime end, int amountPaid, BookingStatus status, DateTime createdAt, String? referenceId, String? unitLabel, String? paymentId, List<String> slotLabels, int players
});




}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? kind = null,Object? title = null,Object? venue = null,Object? sport = null,Object? start = null,Object? end = null,Object? amountPaid = null,Object? status = null,Object? createdAt = null,Object? referenceId = freezed,Object? unitLabel = freezed,Object? paymentId = freezed,Object? slotLabels = null,Object? players = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BookingKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as SportType,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,unitLabel: freezed == unitLabel ? _self.unitLabel : unitLabel // ignore: cast_nullable_to_non_nullable
as String?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,slotLabels: null == slotLabels ? _self.slotLabels : slotLabels // ignore: cast_nullable_to_non_nullable
as List<String>,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Booking].
extension BookingPatterns on Booking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Booking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Booking value)  $default,){
final _that = this;
switch (_that) {
case _Booking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Booking value)?  $default,){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  BookingKind kind,  String title,  String venue,  SportType sport,  DateTime start,  DateTime end,  int amountPaid,  BookingStatus status,  DateTime createdAt,  String? referenceId,  String? unitLabel,  String? paymentId,  List<String> slotLabels,  int players)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.code,_that.kind,_that.title,_that.venue,_that.sport,_that.start,_that.end,_that.amountPaid,_that.status,_that.createdAt,_that.referenceId,_that.unitLabel,_that.paymentId,_that.slotLabels,_that.players);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  BookingKind kind,  String title,  String venue,  SportType sport,  DateTime start,  DateTime end,  int amountPaid,  BookingStatus status,  DateTime createdAt,  String? referenceId,  String? unitLabel,  String? paymentId,  List<String> slotLabels,  int players)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.id,_that.code,_that.kind,_that.title,_that.venue,_that.sport,_that.start,_that.end,_that.amountPaid,_that.status,_that.createdAt,_that.referenceId,_that.unitLabel,_that.paymentId,_that.slotLabels,_that.players);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  BookingKind kind,  String title,  String venue,  SportType sport,  DateTime start,  DateTime end,  int amountPaid,  BookingStatus status,  DateTime createdAt,  String? referenceId,  String? unitLabel,  String? paymentId,  List<String> slotLabels,  int players)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.code,_that.kind,_that.title,_that.venue,_that.sport,_that.start,_that.end,_that.amountPaid,_that.status,_that.createdAt,_that.referenceId,_that.unitLabel,_that.paymentId,_that.slotLabels,_that.players);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Booking extends Booking {
  const _Booking({required this.id, required this.code, required this.kind, required this.title, required this.venue, required this.sport, required this.start, required this.end, required this.amountPaid, required this.status, required this.createdAt, this.referenceId, this.unitLabel, this.paymentId, final  List<String> slotLabels = const <String>[], this.players = 1}): _slotLabels = slotLabels,super._();
  factory _Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

@override final  String id;
@override final  String code;
@override final  BookingKind kind;
@override final  String title;
@override final  String venue;
@override final  SportType sport;
@override final  DateTime start;
@override final  DateTime end;
@override final  int amountPaid;
@override final  BookingStatus status;
@override final  DateTime createdAt;
@override final  String? referenceId;
@override final  String? unitLabel;
@override final  String? paymentId;
 final  List<String> _slotLabels;
@override@JsonKey() List<String> get slotLabels {
  if (_slotLabels is EqualUnmodifiableListView) return _slotLabels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slotLabels);
}

@override@JsonKey() final  int players;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCopyWith<_Booking> get copyWith => __$BookingCopyWithImpl<_Booking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.unitLabel, unitLabel) || other.unitLabel == unitLabel)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&const DeepCollectionEquality().equals(other._slotLabels, _slotLabels)&&(identical(other.players, players) || other.players == players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,kind,title,venue,sport,start,end,amountPaid,status,createdAt,referenceId,unitLabel,paymentId,const DeepCollectionEquality().hash(_slotLabels),players);

@override
String toString() {
  return 'Booking(id: $id, code: $code, kind: $kind, title: $title, venue: $venue, sport: $sport, start: $start, end: $end, amountPaid: $amountPaid, status: $status, createdAt: $createdAt, referenceId: $referenceId, unitLabel: $unitLabel, paymentId: $paymentId, slotLabels: $slotLabels, players: $players)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, BookingKind kind, String title, String venue, SportType sport, DateTime start, DateTime end, int amountPaid, BookingStatus status, DateTime createdAt, String? referenceId, String? unitLabel, String? paymentId, List<String> slotLabels, int players
});




}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? kind = null,Object? title = null,Object? venue = null,Object? sport = null,Object? start = null,Object? end = null,Object? amountPaid = null,Object? status = null,Object? createdAt = null,Object? referenceId = freezed,Object? unitLabel = freezed,Object? paymentId = freezed,Object? slotLabels = null,Object? players = null,}) {
  return _then(_Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BookingKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as SportType,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,unitLabel: freezed == unitLabel ? _self.unitLabel : unitLabel // ignore: cast_nullable_to_non_nullable
as String?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,slotLabels: null == slotLabels ? _self._slotLabels : slotLabels // ignore: cast_nullable_to_non_nullable
as List<String>,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
