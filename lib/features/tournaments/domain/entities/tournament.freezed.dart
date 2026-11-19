// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Tournament {

 String get id; String get name; String get tagline; SportType get sport; String get format; DateTime get startDate; DateTime get endDate; DateTime get registrationCloses; int get entryFee; int get prizePool; int get teamSize; int get maxTeams; int get registeredTeams; TournamentStatus get status; List<String> get rules; List<String> get prizes;
/// Create a copy of Tournament
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentCopyWith<Tournament> get copyWith => _$TournamentCopyWithImpl<Tournament>(this as Tournament, _$identity);

  /// Serializes this Tournament to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tournament&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.format, format) || other.format == format)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.registrationCloses, registrationCloses) || other.registrationCloses == registrationCloses)&&(identical(other.entryFee, entryFee) || other.entryFee == entryFee)&&(identical(other.prizePool, prizePool) || other.prizePool == prizePool)&&(identical(other.teamSize, teamSize) || other.teamSize == teamSize)&&(identical(other.maxTeams, maxTeams) || other.maxTeams == maxTeams)&&(identical(other.registeredTeams, registeredTeams) || other.registeredTeams == registeredTeams)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.rules, rules)&&const DeepCollectionEquality().equals(other.prizes, prizes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,tagline,sport,format,startDate,endDate,registrationCloses,entryFee,prizePool,teamSize,maxTeams,registeredTeams,status,const DeepCollectionEquality().hash(rules),const DeepCollectionEquality().hash(prizes));

@override
String toString() {
  return 'Tournament(id: $id, name: $name, tagline: $tagline, sport: $sport, format: $format, startDate: $startDate, endDate: $endDate, registrationCloses: $registrationCloses, entryFee: $entryFee, prizePool: $prizePool, teamSize: $teamSize, maxTeams: $maxTeams, registeredTeams: $registeredTeams, status: $status, rules: $rules, prizes: $prizes)';
}


}

/// @nodoc
abstract mixin class $TournamentCopyWith<$Res>  {
  factory $TournamentCopyWith(Tournament value, $Res Function(Tournament) _then) = _$TournamentCopyWithImpl;
@useResult
$Res call({
 String id, String name, String tagline, SportType sport, String format, DateTime startDate, DateTime endDate, DateTime registrationCloses, int entryFee, int prizePool, int teamSize, int maxTeams, int registeredTeams, TournamentStatus status, List<String> rules, List<String> prizes
});




}
/// @nodoc
class _$TournamentCopyWithImpl<$Res>
    implements $TournamentCopyWith<$Res> {
  _$TournamentCopyWithImpl(this._self, this._then);

  final Tournament _self;
  final $Res Function(Tournament) _then;

/// Create a copy of Tournament
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? tagline = null,Object? sport = null,Object? format = null,Object? startDate = null,Object? endDate = null,Object? registrationCloses = null,Object? entryFee = null,Object? prizePool = null,Object? teamSize = null,Object? maxTeams = null,Object? registeredTeams = null,Object? status = null,Object? rules = null,Object? prizes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as SportType,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,registrationCloses: null == registrationCloses ? _self.registrationCloses : registrationCloses // ignore: cast_nullable_to_non_nullable
as DateTime,entryFee: null == entryFee ? _self.entryFee : entryFee // ignore: cast_nullable_to_non_nullable
as int,prizePool: null == prizePool ? _self.prizePool : prizePool // ignore: cast_nullable_to_non_nullable
as int,teamSize: null == teamSize ? _self.teamSize : teamSize // ignore: cast_nullable_to_non_nullable
as int,maxTeams: null == maxTeams ? _self.maxTeams : maxTeams // ignore: cast_nullable_to_non_nullable
as int,registeredTeams: null == registeredTeams ? _self.registeredTeams : registeredTeams // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TournamentStatus,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as List<String>,prizes: null == prizes ? _self.prizes : prizes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Tournament].
extension TournamentPatterns on Tournament {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tournament value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tournament() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tournament value)  $default,){
final _that = this;
switch (_that) {
case _Tournament():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tournament value)?  $default,){
final _that = this;
switch (_that) {
case _Tournament() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String tagline,  SportType sport,  String format,  DateTime startDate,  DateTime endDate,  DateTime registrationCloses,  int entryFee,  int prizePool,  int teamSize,  int maxTeams,  int registeredTeams,  TournamentStatus status,  List<String> rules,  List<String> prizes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tournament() when $default != null:
return $default(_that.id,_that.name,_that.tagline,_that.sport,_that.format,_that.startDate,_that.endDate,_that.registrationCloses,_that.entryFee,_that.prizePool,_that.teamSize,_that.maxTeams,_that.registeredTeams,_that.status,_that.rules,_that.prizes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String tagline,  SportType sport,  String format,  DateTime startDate,  DateTime endDate,  DateTime registrationCloses,  int entryFee,  int prizePool,  int teamSize,  int maxTeams,  int registeredTeams,  TournamentStatus status,  List<String> rules,  List<String> prizes)  $default,) {final _that = this;
switch (_that) {
case _Tournament():
return $default(_that.id,_that.name,_that.tagline,_that.sport,_that.format,_that.startDate,_that.endDate,_that.registrationCloses,_that.entryFee,_that.prizePool,_that.teamSize,_that.maxTeams,_that.registeredTeams,_that.status,_that.rules,_that.prizes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String tagline,  SportType sport,  String format,  DateTime startDate,  DateTime endDate,  DateTime registrationCloses,  int entryFee,  int prizePool,  int teamSize,  int maxTeams,  int registeredTeams,  TournamentStatus status,  List<String> rules,  List<String> prizes)?  $default,) {final _that = this;
switch (_that) {
case _Tournament() when $default != null:
return $default(_that.id,_that.name,_that.tagline,_that.sport,_that.format,_that.startDate,_that.endDate,_that.registrationCloses,_that.entryFee,_that.prizePool,_that.teamSize,_that.maxTeams,_that.registeredTeams,_that.status,_that.rules,_that.prizes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Tournament extends Tournament {
  const _Tournament({required this.id, required this.name, required this.tagline, required this.sport, required this.format, required this.startDate, required this.endDate, required this.registrationCloses, required this.entryFee, required this.prizePool, required this.teamSize, required this.maxTeams, required this.registeredTeams, required this.status, final  List<String> rules = const <String>[], final  List<String> prizes = const <String>[]}): _rules = rules,_prizes = prizes,super._();
  factory _Tournament.fromJson(Map<String, dynamic> json) => _$TournamentFromJson(json);

@override final  String id;
@override final  String name;
@override final  String tagline;
@override final  SportType sport;
@override final  String format;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  DateTime registrationCloses;
@override final  int entryFee;
@override final  int prizePool;
@override final  int teamSize;
@override final  int maxTeams;
@override final  int registeredTeams;
@override final  TournamentStatus status;
 final  List<String> _rules;
@override@JsonKey() List<String> get rules {
  if (_rules is EqualUnmodifiableListView) return _rules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rules);
}

 final  List<String> _prizes;
@override@JsonKey() List<String> get prizes {
  if (_prizes is EqualUnmodifiableListView) return _prizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prizes);
}


/// Create a copy of Tournament
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TournamentCopyWith<_Tournament> get copyWith => __$TournamentCopyWithImpl<_Tournament>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TournamentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tournament&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.sport, sport) || other.sport == sport)&&(identical(other.format, format) || other.format == format)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.registrationCloses, registrationCloses) || other.registrationCloses == registrationCloses)&&(identical(other.entryFee, entryFee) || other.entryFee == entryFee)&&(identical(other.prizePool, prizePool) || other.prizePool == prizePool)&&(identical(other.teamSize, teamSize) || other.teamSize == teamSize)&&(identical(other.maxTeams, maxTeams) || other.maxTeams == maxTeams)&&(identical(other.registeredTeams, registeredTeams) || other.registeredTeams == registeredTeams)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._rules, _rules)&&const DeepCollectionEquality().equals(other._prizes, _prizes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,tagline,sport,format,startDate,endDate,registrationCloses,entryFee,prizePool,teamSize,maxTeams,registeredTeams,status,const DeepCollectionEquality().hash(_rules),const DeepCollectionEquality().hash(_prizes));

@override
String toString() {
  return 'Tournament(id: $id, name: $name, tagline: $tagline, sport: $sport, format: $format, startDate: $startDate, endDate: $endDate, registrationCloses: $registrationCloses, entryFee: $entryFee, prizePool: $prizePool, teamSize: $teamSize, maxTeams: $maxTeams, registeredTeams: $registeredTeams, status: $status, rules: $rules, prizes: $prizes)';
}


}

/// @nodoc
abstract mixin class _$TournamentCopyWith<$Res> implements $TournamentCopyWith<$Res> {
  factory _$TournamentCopyWith(_Tournament value, $Res Function(_Tournament) _then) = __$TournamentCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String tagline, SportType sport, String format, DateTime startDate, DateTime endDate, DateTime registrationCloses, int entryFee, int prizePool, int teamSize, int maxTeams, int registeredTeams, TournamentStatus status, List<String> rules, List<String> prizes
});




}
/// @nodoc
class __$TournamentCopyWithImpl<$Res>
    implements _$TournamentCopyWith<$Res> {
  __$TournamentCopyWithImpl(this._self, this._then);

  final _Tournament _self;
  final $Res Function(_Tournament) _then;

/// Create a copy of Tournament
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? tagline = null,Object? sport = null,Object? format = null,Object? startDate = null,Object? endDate = null,Object? registrationCloses = null,Object? entryFee = null,Object? prizePool = null,Object? teamSize = null,Object? maxTeams = null,Object? registeredTeams = null,Object? status = null,Object? rules = null,Object? prizes = null,}) {
  return _then(_Tournament(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tagline: null == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String,sport: null == sport ? _self.sport : sport // ignore: cast_nullable_to_non_nullable
as SportType,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,registrationCloses: null == registrationCloses ? _self.registrationCloses : registrationCloses // ignore: cast_nullable_to_non_nullable
as DateTime,entryFee: null == entryFee ? _self.entryFee : entryFee // ignore: cast_nullable_to_non_nullable
as int,prizePool: null == prizePool ? _self.prizePool : prizePool // ignore: cast_nullable_to_non_nullable
as int,teamSize: null == teamSize ? _self.teamSize : teamSize // ignore: cast_nullable_to_non_nullable
as int,maxTeams: null == maxTeams ? _self.maxTeams : maxTeams // ignore: cast_nullable_to_non_nullable
as int,registeredTeams: null == registeredTeams ? _self.registeredTeams : registeredTeams // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TournamentStatus,rules: null == rules ? _self._rules : rules // ignore: cast_nullable_to_non_nullable
as List<String>,prizes: null == prizes ? _self._prizes : prizes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$TournamentRegistration {

 String get tournamentId; String get teamName; String get captainName; String get captainPhone; int get players;
/// Create a copy of TournamentRegistration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentRegistrationCopyWith<TournamentRegistration> get copyWith => _$TournamentRegistrationCopyWithImpl<TournamentRegistration>(this as TournamentRegistration, _$identity);

  /// Serializes this TournamentRegistration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentRegistration&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.teamName, teamName) || other.teamName == teamName)&&(identical(other.captainName, captainName) || other.captainName == captainName)&&(identical(other.captainPhone, captainPhone) || other.captainPhone == captainPhone)&&(identical(other.players, players) || other.players == players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tournamentId,teamName,captainName,captainPhone,players);

@override
String toString() {
  return 'TournamentRegistration(tournamentId: $tournamentId, teamName: $teamName, captainName: $captainName, captainPhone: $captainPhone, players: $players)';
}


}

/// @nodoc
abstract mixin class $TournamentRegistrationCopyWith<$Res>  {
  factory $TournamentRegistrationCopyWith(TournamentRegistration value, $Res Function(TournamentRegistration) _then) = _$TournamentRegistrationCopyWithImpl;
@useResult
$Res call({
 String tournamentId, String teamName, String captainName, String captainPhone, int players
});




}
/// @nodoc
class _$TournamentRegistrationCopyWithImpl<$Res>
    implements $TournamentRegistrationCopyWith<$Res> {
  _$TournamentRegistrationCopyWithImpl(this._self, this._then);

  final TournamentRegistration _self;
  final $Res Function(TournamentRegistration) _then;

/// Create a copy of TournamentRegistration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tournamentId = null,Object? teamName = null,Object? captainName = null,Object? captainPhone = null,Object? players = null,}) {
  return _then(_self.copyWith(
tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,captainName: null == captainName ? _self.captainName : captainName // ignore: cast_nullable_to_non_nullable
as String,captainPhone: null == captainPhone ? _self.captainPhone : captainPhone // ignore: cast_nullable_to_non_nullable
as String,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TournamentRegistration].
extension TournamentRegistrationPatterns on TournamentRegistration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TournamentRegistration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TournamentRegistration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TournamentRegistration value)  $default,){
final _that = this;
switch (_that) {
case _TournamentRegistration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TournamentRegistration value)?  $default,){
final _that = this;
switch (_that) {
case _TournamentRegistration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tournamentId,  String teamName,  String captainName,  String captainPhone,  int players)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TournamentRegistration() when $default != null:
return $default(_that.tournamentId,_that.teamName,_that.captainName,_that.captainPhone,_that.players);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tournamentId,  String teamName,  String captainName,  String captainPhone,  int players)  $default,) {final _that = this;
switch (_that) {
case _TournamentRegistration():
return $default(_that.tournamentId,_that.teamName,_that.captainName,_that.captainPhone,_that.players);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tournamentId,  String teamName,  String captainName,  String captainPhone,  int players)?  $default,) {final _that = this;
switch (_that) {
case _TournamentRegistration() when $default != null:
return $default(_that.tournamentId,_that.teamName,_that.captainName,_that.captainPhone,_that.players);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TournamentRegistration implements TournamentRegistration {
  const _TournamentRegistration({required this.tournamentId, required this.teamName, required this.captainName, required this.captainPhone, required this.players});
  factory _TournamentRegistration.fromJson(Map<String, dynamic> json) => _$TournamentRegistrationFromJson(json);

@override final  String tournamentId;
@override final  String teamName;
@override final  String captainName;
@override final  String captainPhone;
@override final  int players;

/// Create a copy of TournamentRegistration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TournamentRegistrationCopyWith<_TournamentRegistration> get copyWith => __$TournamentRegistrationCopyWithImpl<_TournamentRegistration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TournamentRegistrationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TournamentRegistration&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.teamName, teamName) || other.teamName == teamName)&&(identical(other.captainName, captainName) || other.captainName == captainName)&&(identical(other.captainPhone, captainPhone) || other.captainPhone == captainPhone)&&(identical(other.players, players) || other.players == players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tournamentId,teamName,captainName,captainPhone,players);

@override
String toString() {
  return 'TournamentRegistration(tournamentId: $tournamentId, teamName: $teamName, captainName: $captainName, captainPhone: $captainPhone, players: $players)';
}


}

/// @nodoc
abstract mixin class _$TournamentRegistrationCopyWith<$Res> implements $TournamentRegistrationCopyWith<$Res> {
  factory _$TournamentRegistrationCopyWith(_TournamentRegistration value, $Res Function(_TournamentRegistration) _then) = __$TournamentRegistrationCopyWithImpl;
@override @useResult
$Res call({
 String tournamentId, String teamName, String captainName, String captainPhone, int players
});




}
/// @nodoc
class __$TournamentRegistrationCopyWithImpl<$Res>
    implements _$TournamentRegistrationCopyWith<$Res> {
  __$TournamentRegistrationCopyWithImpl(this._self, this._then);

  final _TournamentRegistration _self;
  final $Res Function(_TournamentRegistration) _then;

/// Create a copy of TournamentRegistration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tournamentId = null,Object? teamName = null,Object? captainName = null,Object? captainPhone = null,Object? players = null,}) {
  return _then(_TournamentRegistration(
tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,captainName: null == captainName ? _self.captainName : captainName // ignore: cast_nullable_to_non_nullable
as String,captainPhone: null == captainPhone ? _self.captainPhone : captainPhone // ignore: cast_nullable_to_non_nullable
as String,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
