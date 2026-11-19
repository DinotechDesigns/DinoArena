// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'arena_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArenaEvent {

 String get id; String get title; String get subtitle; String get description; EventCadence get cadence; SportType get sport; DateTime get start; DateTime get end; String get venue; int get fee; int get capacity; int get registered; String get level; List<String> get highlights;
/// Create a copy of ArenaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArenaEventCopyWith<ArenaEvent> get copyWith => _$ArenaEventCopyWithImpl<ArenaEvent>(this as ArenaEvent, _$identity);

  /// Serializes this ArenaEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArenaEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.fee, fee) || other.fee == fee)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.registered, registered) || other.registered == registered)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other.highlights, highlights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,description,cadence,sport,start,end,venue,fee,capacity,registered,level,const DeepCollectionEquality().hash(highlights));

@override
String toString() {
  return 'ArenaEvent(id: $id, title: $title, subtitle: $subtitle, description: $description, cadence: $cadence, sport: $sport, start: $start, end: $end, venue: $venue, fee: $fee, capacity: $capacity, registered: $registered, level: $level, highlights: $highlights)';
}


}

/// @nodoc
abstract mixin class $ArenaEventCopyWith<$Res>  {
  factory $ArenaEventCopyWith(ArenaEvent value, $Res Function(ArenaEvent) _then) = _$ArenaEventCopyWithImpl;
@useResult
$Res call({
 String id, String title, String subtitle, String description, EventCadence cadence, SportType sport, DateTime start, DateTime end, String venue, int fee, int capacity, int registered, String level, List<String> highlights
});




}
/// @nodoc
class _$ArenaEventCopyWithImpl<$Res>
    implements $ArenaEventCopyWith<$Res> {
  _$ArenaEventCopyWithImpl(this._self, this._then);

  final ArenaEvent _self;
  final $Res Function(ArenaEvent) _then;

/// Create a copy of ArenaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? description = null,Object? cadence = null,Object? sport = null,Object? start = null,Object? end = null,Object? venue = null,Object? fee = null,Object? capacity = null,Object? registered = null,Object? level = null,Object? highlights = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,cadence: null == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as EventCadence,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as SportType,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,fee: null == fee ? _self.fee : fee // ignore: cast_nullable_to_non_nullable
as int,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,registered: null == registered ? _self.registered : registered // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,highlights: null == highlights ? _self.highlights : highlights // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ArenaEvent].
extension ArenaEventPatterns on ArenaEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArenaEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArenaEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArenaEvent value)  $default,){
final _that = this;
switch (_that) {
case _ArenaEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArenaEvent value)?  $default,){
final _that = this;
switch (_that) {
case _ArenaEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  String description,  EventCadence cadence,  SportType sport,  DateTime start,  DateTime end,  String venue,  int fee,  int capacity,  int registered,  String level,  List<String> highlights)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArenaEvent() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.description,_that.cadence,_that.sport,_that.start,_that.end,_that.venue,_that.fee,_that.capacity,_that.registered,_that.level,_that.highlights);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  String description,  EventCadence cadence,  SportType sport,  DateTime start,  DateTime end,  String venue,  int fee,  int capacity,  int registered,  String level,  List<String> highlights)  $default,) {final _that = this;
switch (_that) {
case _ArenaEvent():
return $default(_that.id,_that.title,_that.subtitle,_that.description,_that.cadence,_that.sport,_that.start,_that.end,_that.venue,_that.fee,_that.capacity,_that.registered,_that.level,_that.highlights);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String subtitle,  String description,  EventCadence cadence,  SportType sport,  DateTime start,  DateTime end,  String venue,  int fee,  int capacity,  int registered,  String level,  List<String> highlights)?  $default,) {final _that = this;
switch (_that) {
case _ArenaEvent() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.description,_that.cadence,_that.sport,_that.start,_that.end,_that.venue,_that.fee,_that.capacity,_that.registered,_that.level,_that.highlights);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArenaEvent extends ArenaEvent {
  const _ArenaEvent({required this.id, required this.title, required this.subtitle, required this.description, required this.cadence, required this.sport, required this.start, required this.end, required this.venue, required this.fee, required this.capacity, required this.registered, required this.level, final  List<String> highlights = const <String>[]}): _highlights = highlights,super._();
  factory _ArenaEvent.fromJson(Map<String, dynamic> json) => _$ArenaEventFromJson(json);

@override final  String id;
@override final  String title;
@override final  String subtitle;
@override final  String description;
@override final  EventCadence cadence;
@override final  SportType sport;
@override final  DateTime start;
@override final  DateTime end;
@override final  String venue;
@override final  int fee;
@override final  int capacity;
@override final  int registered;
@override final  String level;
 final  List<String> _highlights;
@override@JsonKey() List<String> get highlights {
  if (_highlights is EqualUnmodifiableListView) return _highlights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_highlights);
}


/// Create a copy of ArenaEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArenaEventCopyWith<_ArenaEvent> get copyWith => __$ArenaEventCopyWithImpl<_ArenaEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArenaEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArenaEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.fee, fee) || other.fee == fee)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.registered, registered) || other.registered == registered)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other._highlights, _highlights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,description,cadence,sport,start,end,venue,fee,capacity,registered,level,const DeepCollectionEquality().hash(_highlights));

@override
String toString() {
  return 'ArenaEvent(id: $id, title: $title, subtitle: $subtitle, description: $description, cadence: $cadence, sport: $sport, start: $start, end: $end, venue: $venue, fee: $fee, capacity: $capacity, registered: $registered, level: $level, highlights: $highlights)';
}


}

/// @nodoc
abstract mixin class _$ArenaEventCopyWith<$Res> implements $ArenaEventCopyWith<$Res> {
  factory _$ArenaEventCopyWith(_ArenaEvent value, $Res Function(_ArenaEvent) _then) = __$ArenaEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String subtitle, String description, EventCadence cadence, SportType sport, DateTime start, DateTime end, String venue, int fee, int capacity, int registered, String level, List<String> highlights
});




}
/// @nodoc
class __$ArenaEventCopyWithImpl<$Res>
    implements _$ArenaEventCopyWith<$Res> {
  __$ArenaEventCopyWithImpl(this._self, this._then);

  final _ArenaEvent _self;
  final $Res Function(_ArenaEvent) _then;

/// Create a copy of ArenaEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? description = null,Object? cadence = null,Object? sport = null,Object? start = null,Object? end = null,Object? venue = null,Object? fee = null,Object? capacity = null,Object? registered = null,Object? level = null,Object? highlights = null,}) {
  return _then(_ArenaEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,cadence: null == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as EventCadence,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as SportType,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,fee: null == fee ? _self.fee : fee // ignore: cast_nullable_to_non_nullable
as int,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,registered: null == registered ? _self.registered : registered // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,highlights: null == highlights ? _self._highlights : highlights // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
