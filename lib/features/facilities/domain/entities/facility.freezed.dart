// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facility.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Facility {

 String get id; String get name; String get headline; FacilityKind get kind; List<SportType> get sports; String get description; int get pricePerHour; int get peakPricePerHour; double get rating; int get reviewCount; int get openHour; int get closeHour; String get surface; String get dimensions; int get maxPlayers; int get units; String get unitLabel; List<String> get amenities; List<String> get rules; bool get featured; String? get badge;
/// Create a copy of Facility
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FacilityCopyWith<Facility> get copyWith => _$FacilityCopyWithImpl<Facility>(this as Facility, _$identity);

  /// Serializes this Facility to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Facility&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other.sports, sports)&&(identical(other.description, description) || other.description == description)&&(identical(other.pricePerHour, pricePerHour) || other.pricePerHour == pricePerHour)&&(identical(other.peakPricePerHour, peakPricePerHour) || other.peakPricePerHour == peakPricePerHour)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.openHour, openHour) || other.openHour == openHour)&&(identical(other.closeHour, closeHour) || other.closeHour == closeHour)&&(identical(other.surface, surface) || other.surface == surface)&&(identical(other.dimensions, dimensions) || other.dimensions == dimensions)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers)&&(identical(other.units, units) || other.units == units)&&(identical(other.unitLabel, unitLabel) || other.unitLabel == unitLabel)&&const DeepCollectionEquality().equals(other.amenities, amenities)&&const DeepCollectionEquality().equals(other.rules, rules)&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.badge, badge) || other.badge == badge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,headline,kind,const DeepCollectionEquality().hash(sports),description,pricePerHour,peakPricePerHour,rating,reviewCount,openHour,closeHour,surface,dimensions,maxPlayers,units,unitLabel,const DeepCollectionEquality().hash(amenities),const DeepCollectionEquality().hash(rules),featured,badge]);

@override
String toString() {
  return 'Facility(id: $id, name: $name, headline: $headline, kind: $kind, sports: $sports, description: $description, pricePerHour: $pricePerHour, peakPricePerHour: $peakPricePerHour, rating: $rating, reviewCount: $reviewCount, openHour: $openHour, closeHour: $closeHour, surface: $surface, dimensions: $dimensions, maxPlayers: $maxPlayers, units: $units, unitLabel: $unitLabel, amenities: $amenities, rules: $rules, featured: $featured, badge: $badge)';
}


}

/// @nodoc
abstract mixin class $FacilityCopyWith<$Res>  {
  factory $FacilityCopyWith(Facility value, $Res Function(Facility) _then) = _$FacilityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String headline, FacilityKind kind, List<SportType> sports, String description, int pricePerHour, int peakPricePerHour, double rating, int reviewCount, int openHour, int closeHour, String surface, String dimensions, int maxPlayers, int units, String unitLabel, List<String> amenities, List<String> rules, bool featured, String? badge
});




}
/// @nodoc
class _$FacilityCopyWithImpl<$Res>
    implements $FacilityCopyWith<$Res> {
  _$FacilityCopyWithImpl(this._self, this._then);

  final Facility _self;
  final $Res Function(Facility) _then;

/// Create a copy of Facility
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? headline = null,Object? kind = null,Object? sports = null,Object? description = null,Object? pricePerHour = null,Object? peakPricePerHour = null,Object? rating = null,Object? reviewCount = null,Object? openHour = null,Object? closeHour = null,Object? surface = null,Object? dimensions = null,Object? maxPlayers = null,Object? units = null,Object? unitLabel = null,Object? amenities = null,Object? rules = null,Object? featured = null,Object? badge = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FacilityKind,sports: null == sports ? _self.sports : sports // ignore: cast_nullable_to_non_nullable
as List<SportType>,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,pricePerHour: null == pricePerHour ? _self.pricePerHour : pricePerHour // ignore: cast_nullable_to_non_nullable
as int,peakPricePerHour: null == peakPricePerHour ? _self.peakPricePerHour : peakPricePerHour // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,openHour: null == openHour ? _self.openHour : openHour // ignore: cast_nullable_to_non_nullable
as int,closeHour: null == closeHour ? _self.closeHour : closeHour // ignore: cast_nullable_to_non_nullable
as int,surface: null == surface ? _self.surface : surface // ignore: cast_nullable_to_non_nullable
as String,dimensions: null == dimensions ? _self.dimensions : dimensions // ignore: cast_nullable_to_non_nullable
as String,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,unitLabel: null == unitLabel ? _self.unitLabel : unitLabel // ignore: cast_nullable_to_non_nullable
as String,amenities: null == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as List<String>,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Facility].
extension FacilityPatterns on Facility {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Facility value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Facility() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Facility value)  $default,){
final _that = this;
switch (_that) {
case _Facility():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Facility value)?  $default,){
final _that = this;
switch (_that) {
case _Facility() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String headline,  FacilityKind kind,  List<SportType> sports,  String description,  int pricePerHour,  int peakPricePerHour,  double rating,  int reviewCount,  int openHour,  int closeHour,  String surface,  String dimensions,  int maxPlayers,  int units,  String unitLabel,  List<String> amenities,  List<String> rules,  bool featured,  String? badge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Facility() when $default != null:
return $default(_that.id,_that.name,_that.headline,_that.kind,_that.sports,_that.description,_that.pricePerHour,_that.peakPricePerHour,_that.rating,_that.reviewCount,_that.openHour,_that.closeHour,_that.surface,_that.dimensions,_that.maxPlayers,_that.units,_that.unitLabel,_that.amenities,_that.rules,_that.featured,_that.badge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String headline,  FacilityKind kind,  List<SportType> sports,  String description,  int pricePerHour,  int peakPricePerHour,  double rating,  int reviewCount,  int openHour,  int closeHour,  String surface,  String dimensions,  int maxPlayers,  int units,  String unitLabel,  List<String> amenities,  List<String> rules,  bool featured,  String? badge)  $default,) {final _that = this;
switch (_that) {
case _Facility():
return $default(_that.id,_that.name,_that.headline,_that.kind,_that.sports,_that.description,_that.pricePerHour,_that.peakPricePerHour,_that.rating,_that.reviewCount,_that.openHour,_that.closeHour,_that.surface,_that.dimensions,_that.maxPlayers,_that.units,_that.unitLabel,_that.amenities,_that.rules,_that.featured,_that.badge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String headline,  FacilityKind kind,  List<SportType> sports,  String description,  int pricePerHour,  int peakPricePerHour,  double rating,  int reviewCount,  int openHour,  int closeHour,  String surface,  String dimensions,  int maxPlayers,  int units,  String unitLabel,  List<String> amenities,  List<String> rules,  bool featured,  String? badge)?  $default,) {final _that = this;
switch (_that) {
case _Facility() when $default != null:
return $default(_that.id,_that.name,_that.headline,_that.kind,_that.sports,_that.description,_that.pricePerHour,_that.peakPricePerHour,_that.rating,_that.reviewCount,_that.openHour,_that.closeHour,_that.surface,_that.dimensions,_that.maxPlayers,_that.units,_that.unitLabel,_that.amenities,_that.rules,_that.featured,_that.badge);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Facility extends Facility {
  const _Facility({required this.id, required this.name, required this.headline, required this.kind, required final  List<SportType> sports, required this.description, required this.pricePerHour, required this.peakPricePerHour, required this.rating, required this.reviewCount, required this.openHour, required this.closeHour, required this.surface, required this.dimensions, required this.maxPlayers, this.units = 1, this.unitLabel = 'Court', final  List<String> amenities = const <String>[], final  List<String> rules = const <String>[], this.featured = false, this.badge}): _sports = sports,_amenities = amenities,_rules = rules,super._();
  factory _Facility.fromJson(Map<String, dynamic> json) => _$FacilityFromJson(json);

@override final  String id;
@override final  String name;
@override final  String headline;
@override final  FacilityKind kind;
 final  List<SportType> _sports;
@override List<SportType> get sports {
  if (_sports is EqualUnmodifiableListView) return _sports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sports);
}

@override final  String description;
@override final  int pricePerHour;
@override final  int peakPricePerHour;
@override final  double rating;
@override final  int reviewCount;
@override final  int openHour;
@override final  int closeHour;
@override final  String surface;
@override final  String dimensions;
@override final  int maxPlayers;
@override@JsonKey() final  int units;
@override@JsonKey() final  String unitLabel;
 final  List<String> _amenities;
@override@JsonKey() List<String> get amenities {
  if (_amenities is EqualUnmodifiableListView) return _amenities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_amenities);
}

 final  List<String> _rules;
@override@JsonKey() List<String> get rules {
  if (_rules is EqualUnmodifiableListView) return _rules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rules);
}

@override@JsonKey() final  bool featured;
@override final  String? badge;

/// Create a copy of Facility
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FacilityCopyWith<_Facility> get copyWith => __$FacilityCopyWithImpl<_Facility>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FacilityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Facility&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.headline, headline) || other.headline == headline)&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other._sports, _sports)&&(identical(other.description, description) || other.description == description)&&(identical(other.pricePerHour, pricePerHour) || other.pricePerHour == pricePerHour)&&(identical(other.peakPricePerHour, peakPricePerHour) || other.peakPricePerHour == peakPricePerHour)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.openHour, openHour) || other.openHour == openHour)&&(identical(other.closeHour, closeHour) || other.closeHour == closeHour)&&(identical(other.surface, surface) || other.surface == surface)&&(identical(other.dimensions, dimensions) || other.dimensions == dimensions)&&(identical(other.maxPlayers, maxPlayers) || other.maxPlayers == maxPlayers)&&(identical(other.units, units) || other.units == units)&&(identical(other.unitLabel, unitLabel) || other.unitLabel == unitLabel)&&const DeepCollectionEquality().equals(other._amenities, _amenities)&&const DeepCollectionEquality().equals(other._rules, _rules)&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.badge, badge) || other.badge == badge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,headline,kind,const DeepCollectionEquality().hash(_sports),description,pricePerHour,peakPricePerHour,rating,reviewCount,openHour,closeHour,surface,dimensions,maxPlayers,units,unitLabel,const DeepCollectionEquality().hash(_amenities),const DeepCollectionEquality().hash(_rules),featured,badge]);

@override
String toString() {
  return 'Facility(id: $id, name: $name, headline: $headline, kind: $kind, sports: $sports, description: $description, pricePerHour: $pricePerHour, peakPricePerHour: $peakPricePerHour, rating: $rating, reviewCount: $reviewCount, openHour: $openHour, closeHour: $closeHour, surface: $surface, dimensions: $dimensions, maxPlayers: $maxPlayers, units: $units, unitLabel: $unitLabel, amenities: $amenities, rules: $rules, featured: $featured, badge: $badge)';
}


}

/// @nodoc
abstract mixin class _$FacilityCopyWith<$Res> implements $FacilityCopyWith<$Res> {
  factory _$FacilityCopyWith(_Facility value, $Res Function(_Facility) _then) = __$FacilityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String headline, FacilityKind kind, List<SportType> sports, String description, int pricePerHour, int peakPricePerHour, double rating, int reviewCount, int openHour, int closeHour, String surface, String dimensions, int maxPlayers, int units, String unitLabel, List<String> amenities, List<String> rules, bool featured, String? badge
});




}
/// @nodoc
class __$FacilityCopyWithImpl<$Res>
    implements _$FacilityCopyWith<$Res> {
  __$FacilityCopyWithImpl(this._self, this._then);

  final _Facility _self;
  final $Res Function(_Facility) _then;

/// Create a copy of Facility
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? headline = null,Object? kind = null,Object? sports = null,Object? description = null,Object? pricePerHour = null,Object? peakPricePerHour = null,Object? rating = null,Object? reviewCount = null,Object? openHour = null,Object? closeHour = null,Object? surface = null,Object? dimensions = null,Object? maxPlayers = null,Object? units = null,Object? unitLabel = null,Object? amenities = null,Object? rules = null,Object? featured = null,Object? badge = freezed,}) {
  return _then(_Facility(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,headline: null == headline ? _self.headline : headline // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FacilityKind,sports: null == sports ? _self._sports : sports // ignore: cast_nullable_to_non_nullable
as List<SportType>,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,pricePerHour: null == pricePerHour ? _self.pricePerHour : pricePerHour // ignore: cast_nullable_to_non_nullable
as int,peakPricePerHour: null == peakPricePerHour ? _self.peakPricePerHour : peakPricePerHour // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,openHour: null == openHour ? _self.openHour : openHour // ignore: cast_nullable_to_non_nullable
as int,closeHour: null == closeHour ? _self.closeHour : closeHour // ignore: cast_nullable_to_non_nullable
as int,surface: null == surface ? _self.surface : surface // ignore: cast_nullable_to_non_nullable
as String,dimensions: null == dimensions ? _self.dimensions : dimensions // ignore: cast_nullable_to_non_nullable
as String,maxPlayers: null == maxPlayers ? _self.maxPlayers : maxPlayers // ignore: cast_nullable_to_non_nullable
as int,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,unitLabel: null == unitLabel ? _self.unitLabel : unitLabel // ignore: cast_nullable_to_non_nullable
as String,amenities: null == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,rules: null == rules ? _self._rules : rules // ignore: cast_nullable_to_non_nullable
as List<String>,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
