import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/theme/app_colors.dart';

@JsonEnum(valueField: 'apiValue')
enum SportType {
  cricket('cricket', 'Box Cricket', Icons.sports_cricket),
  football('football', 'Football', Icons.sports_soccer),
  badminton('badminton', 'Badminton', Icons.sports_tennis),
  cricketNets('cricket_nets', 'Cricket Nets', Icons.sports_baseball);

  const SportType(this.apiValue, this.label, this.icon);

  final String apiValue;
  final String label;
  final IconData icon;

  Color get tint => switch (this) {
    SportType.cricket => AppColors.primaryGreen,
    SportType.football => const Color(0xFF2E9E6E),
    SportType.badminton => const Color(0xFF3C8DAE),
    SportType.cricketNets => const Color(0xFF7A9B2F),
  };
}
