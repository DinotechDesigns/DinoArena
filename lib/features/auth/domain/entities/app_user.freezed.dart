// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

 String get id; String get phone; String get name; String? get email; DateTime get memberSince; int get gamesPlayed; int get hoursPlayed; int get tournamentsPlayed;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.memberSince, memberSince) || other.memberSince == memberSince)&&(identical(other.gamesPlayed, gamesPlayed) || other.gamesPlayed == gamesPlayed)&&(identical(other.hoursPlayed, hoursPlayed) || other.hoursPlayed == hoursPlayed)&&(identical(other.tournamentsPlayed, tournamentsPlayed) || other.tournamentsPlayed == tournamentsPlayed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,phone,name,email,memberSince,gamesPlayed,hoursPlayed,tournamentsPlayed);

@override
String toString() {
  return 'AppUser(id: $id, phone: $phone, name: $name, email: $email, memberSince: $memberSince, gamesPlayed: $gamesPlayed, hoursPlayed: $hoursPlayed, tournamentsPlayed: $tournamentsPlayed)';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
 String id, String phone, String name, String? email, DateTime memberSince, int gamesPlayed, int hoursPlayed, int tournamentsPlayed
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? phone = null,Object? name = null,Object? email = freezed,Object? memberSince = null,Object? gamesPlayed = null,Object? hoursPlayed = null,Object? tournamentsPlayed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,memberSince: null == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime,gamesPlayed: null == gamesPlayed ? _self.gamesPlayed : gamesPlayed // ignore: cast_nullable_to_non_nullable
as int,hoursPlayed: null == hoursPlayed ? _self.hoursPlayed : hoursPlayed // ignore: cast_nullable_to_non_nullable
as int,tournamentsPlayed: null == tournamentsPlayed ? _self.tournamentsPlayed : tournamentsPlayed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String phone,  String name,  String? email,  DateTime memberSince,  int gamesPlayed,  int hoursPlayed,  int tournamentsPlayed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.phone,_that.name,_that.email,_that.memberSince,_that.gamesPlayed,_that.hoursPlayed,_that.tournamentsPlayed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String phone,  String name,  String? email,  DateTime memberSince,  int gamesPlayed,  int hoursPlayed,  int tournamentsPlayed)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.id,_that.phone,_that.name,_that.email,_that.memberSince,_that.gamesPlayed,_that.hoursPlayed,_that.tournamentsPlayed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String phone,  String name,  String? email,  DateTime memberSince,  int gamesPlayed,  int hoursPlayed,  int tournamentsPlayed)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.phone,_that.name,_that.email,_that.memberSince,_that.gamesPlayed,_that.hoursPlayed,_that.tournamentsPlayed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser extends AppUser {
  const _AppUser({required this.id, required this.phone, required this.name, this.email, required this.memberSince, this.gamesPlayed = 0, this.hoursPlayed = 0, this.tournamentsPlayed = 0}): super._();
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override final  String id;
@override final  String phone;
@override final  String name;
@override final  String? email;
@override final  DateTime memberSince;
@override@JsonKey() final  int gamesPlayed;
@override@JsonKey() final  int hoursPlayed;
@override@JsonKey() final  int tournamentsPlayed;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.memberSince, memberSince) || other.memberSince == memberSince)&&(identical(other.gamesPlayed, gamesPlayed) || other.gamesPlayed == gamesPlayed)&&(identical(other.hoursPlayed, hoursPlayed) || other.hoursPlayed == hoursPlayed)&&(identical(other.tournamentsPlayed, tournamentsPlayed) || other.tournamentsPlayed == tournamentsPlayed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,phone,name,email,memberSince,gamesPlayed,hoursPlayed,tournamentsPlayed);

@override
String toString() {
  return 'AppUser(id: $id, phone: $phone, name: $name, email: $email, memberSince: $memberSince, gamesPlayed: $gamesPlayed, hoursPlayed: $hoursPlayed, tournamentsPlayed: $tournamentsPlayed)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String phone, String name, String? email, DateTime memberSince, int gamesPlayed, int hoursPlayed, int tournamentsPlayed
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? phone = null,Object? name = null,Object? email = freezed,Object? memberSince = null,Object? gamesPlayed = null,Object? hoursPlayed = null,Object? tournamentsPlayed = null,}) {
  return _then(_AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,memberSince: null == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime,gamesPlayed: null == gamesPlayed ? _self.gamesPlayed : gamesPlayed // ignore: cast_nullable_to_non_nullable
as int,hoursPlayed: null == hoursPlayed ? _self.hoursPlayed : hoursPlayed // ignore: cast_nullable_to_non_nullable
as int,tournamentsPlayed: null == tournamentsPlayed ? _self.tournamentsPlayed : tournamentsPlayed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
