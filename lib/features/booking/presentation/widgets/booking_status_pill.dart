import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common.dart';
import '../../domain/entities/booking.dart';

class BookingStatusPill extends StatelessWidget {
  const BookingStatusPill({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (booking.status) {
      BookingStatus.pending => ('Pending', AppColors.warning, Icons.hourglass_top_rounded),
      BookingStatus.cancelled => ('Cancelled', AppColors.error, Icons.cancel_rounded),
      BookingStatus.completed => ('Completed', AppColors.textSecondary, Icons.done_all_rounded),
      BookingStatus.confirmed when booking.isPast => ('Completed', AppColors.textSecondary, Icons.done_all_rounded),
      BookingStatus.confirmed => ('Confirmed', AppColors.primaryGreen, Icons.verified_rounded),
    };
    return Pill(label: label, color: color, icon: icon, dense: true);
  }
}
