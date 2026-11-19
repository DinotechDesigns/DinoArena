import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/constants/brand.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/dinoarena_logo.dart';
import '../../domain/entities/booking.dart';
import '../providers/booking_providers.dart';
import '../widgets/booking_status_pill.dart';

class BookingPassScreen extends ConsumerWidget {
  const BookingPassScreen({super.key, required this.bookingId});

  final String bookingId;

  Future<void> _cancel(BuildContext context, WidgetRef ref, Booking b) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel this booking?'),
        content: Text(
          'Your ${Fmt.money(b.amountPaid)} refund goes back to the original payment method within 5–7 working days.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Keep it')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(bookingsControllerProvider.notifier).cancel(b.id);
      if (context.mounted) {
        showAppSnack(context, 'Booking cancelled. Refund initiated.', icon: Icons.check_circle_rounded);
      }
    } catch (e) {
      if (context.mounted) showAppSnack(context, e.toString(), icon: Icons.error_outline_rounded);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingsControllerProvider);
    final b = ref.watch(bookingByIdProvider(bookingId));

    if (b == null) {
      return Scaffold(
        appBar: const AppTopBar(title: 'Pass'),
        body: bookings.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
            : const EmptyState(
                icon: Icons.confirmation_number_outlined,
                title: 'Pass not found',
                message: 'This booking may have been removed.',
              ),
      );
    }
    final t = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.darkOverlay,
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.md, 8, AppSpacing.md, 0),
                  child: Row(
                    children: [
                      const AppBackButton(onDark: true),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('${Brand.name} pass', style: t.titleLarge?.copyWith(color: Colors.white)),
                      ),
                      CircleIconButton(
                        icon: Icons.copy_rounded,
                        tooltip: 'Copy booking ID',
                        background: Colors.white.withValues(alpha: .1),
                        foreground: Colors.white,
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: b.code));
                          showAppSnack(context, 'Booking ID ${b.code} copied', icon: Icons.copy_rounded);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 20, AppSpacing.gutter, 24),
                    child: Column(
                      children: [
                        _Ticket(
                          booking: b,
                        ).animate().fadeIn(duration: 450.ms).slideY(begin: .08, curve: Curves.easeOutCubic),
                        const SizedBox(height: 20),
                        if (b.status == BookingStatus.confirmed && b.isUpcoming)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.brightness_high_rounded, size: 16, color: Colors.white60),
                              const SizedBox(width: 6),
                              Text(
                                'Turn up brightness and show this at the gate',
                                style: t.bodySmall?.copyWith(color: Colors.white60),
                              ),
                            ],
                          ),
                        const SizedBox(height: 20),
                        if (b.canCancel)
                          AppButton(
                            label: 'Cancel booking',
                            variant: AppButtonVariant.ghostOnDark,
                            icon: Icons.event_busy_rounded,
                            onPressed: () => _cancel(context, ref, b),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Ticket extends StatelessWidget {
  const _Ticket({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final b = booking;
    final active = b.status == BookingStatus.confirmed && b.isUpcoming;
    final pending = b.status == BookingStatus.pending;

    final details = <(String, String)>[
      ('Date', Fmt.date(b.start)),
      ('Time', Fmt.timeRange(b.start, b.end)),
      ('Venue', b.venue),
      if (b.unitLabel != null) ('Area', b.unitLabel!),
      (b.kind == BookingKind.tournament ? 'Squad' : 'Players', '${b.players}'),
      ('Paid', Fmt.money(b.amountPaid)),
    ];

    return PhysicalShape(
      clipper: const _TicketClipper(notchY: 353),
      color: AppColors.surface,
      elevation: 12,
      shadowColor: Colors.black54,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            decoration: const BoxDecoration(color: AppColors.background),
            child: Row(
              children: [
                const DinoArenaWordmark(size: 30),
                const Spacer(),
                BookingStatusPill(booking: b),
              ],
            ),
          ),
          // QR
          SizedBox(
            height: 230,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: active ? 0 : 6, sigmaY: active ? 0 : 6),
                    child: Opacity(
                      opacity: active ? 1 : .35,
                      child: QrImageView(
                        data: b.qrPayload,
                        size: 190,
                        padding: EdgeInsets.zero,
                        eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.primaryDark),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                          color: AppColors.primaryDark,
                        ),
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                      ),
                    ),
                  ),
                  if (active)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: const DinoArenaMark(size: 38),
                    ),
                  if (!active)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(color: AppColors.primaryDark, borderRadius: BorderRadius.circular(14)),
                      child: Text(
                        pending
                            ? 'Activates once payment clears'
                            : (b.status == BookingStatus.cancelled ? 'Booking cancelled' : 'Pass used'),
                        style: t.labelMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Text(b.code, style: t.titleLarge?.copyWith(letterSpacing: 3)),
          const SizedBox(height: 4),
          Text('Booking ID', style: t.bodySmall?.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 14),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 26), child: DashedLine()),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppColors.limeSoft, borderRadius: BorderRadius.circular(14)),
                  child: Icon(b.sport.icon, color: AppColors.primaryGreen),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(b.title, style: t.titleMedium)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: LayoutBuilder(
              builder: (context, c) => Wrap(
                runSpacing: 14,
                children: [
                  for (final (label, value) in details)
                    SizedBox(
                      width: c.maxWidth / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label.toUpperCase(),
                            style: t.labelSmall?.copyWith(color: AppColors.textMuted, letterSpacing: 1.2, fontSize: 10),
                          ),
                          const SizedBox(height: 3),
                          Text(value, style: t.labelLarge),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (b.slotLabels.length > 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [for (final s in b.slotLabels) Pill(label: s, dense: true)],
              ),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: AppColors.primaryDark,
            child: Text(
              Brand.tagline,
              textAlign: TextAlign.center,
              style: t.labelSmall?.copyWith(color: AppColors.accentLime, letterSpacing: 3),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded ticket with side notches at the tear line.
class _TicketClipper extends CustomClipper<Path> {
  const _TicketClipper({required this.notchY});

  final double notchY;

  @override
  Path getClip(Size size) {
    const r = 22.0;
    const notch = 14.0;
    final y = notchY; // aligned with the dashed tear line
    final shape = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(r)));
    final cuts = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, y), radius: notch))
      ..addOval(Rect.fromCircle(center: Offset(size.width, y), radius: notch));
    return Path.combine(PathOperation.difference, shape, cuts);
  }

  @override
  bool shouldReclip(_TicketClipper old) => old.notchY != notchY;
}
