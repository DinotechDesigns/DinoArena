import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/common.dart';
import '../../../booking/presentation/providers/booking_providers.dart';
import '../../domain/entities/payment.dart';
import '../providers/checkout_providers.dart';
import 'checkout_screen.dart';

class PaymentResultScreen extends ConsumerStatefulWidget {
  const PaymentResultScreen({super.key});

  @override
  ConsumerState<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends ConsumerState<PaymentResultScreen> {
  Timer? _autoCheck;

  @override
  void initState() {
    super.initState();
    final status = ref.read(checkoutControllerProvider).result?.status;
    HapticFeedback.vibrate();
    if (status == PaymentStatus.pending) {
      _autoCheck = Timer(const Duration(seconds: 5), _checkPending);
    }
  }

  Future<void> _checkPending() async {
    final status = await ref.read(checkoutControllerProvider.notifier).refreshPending();
    if (status == PaymentStatus.success) HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _autoCheck?.cancel();
    super.dispose();
  }

  void _finish() {
    ref.read(bookingDraftProvider.notifier).clear();
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final state = ref.watch(checkoutControllerProvider);
    final result = state.result;
    if (result == null) {
      return Scaffold(
        body: EmptyState(
          icon: Icons.receipt_long_rounded,
          title: 'No payment found',
          message: '',
          actionLabel: 'Go home',
          onAction: _finish,
        ),
      );
    }

    final (color, soft, icon, title, message) = switch (result.status) {
      PaymentStatus.success => (
        AppColors.primaryGreen,
        AppColors.limeSoft,
        Icons.check_rounded,
        'Payment successful',
        'You’re all set. Your DinoArena pass is ready to scan at the gate.',
      ),
      PaymentStatus.pending => (
        AppColors.warning,
        AppColors.warningSoft,
        Icons.hourglass_top_rounded,
        'Payment pending',
        'Your bank is still confirming this payment. We’ve reserved your spot and will confirm automatically.',
      ),
      PaymentStatus.failed => (
        AppColors.error,
        AppColors.errorSoft,
        Icons.close_rounded,
        'Payment failed',
        result.failureReason ?? 'The payment didn’t go through. No money was deducted.',
      ),
    };
    final booking = state.booking;
    final request = state.request;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finish();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 40, AppSpacing.gutter, 24),
                  child: Column(
                    children: [
                      _StatusBadge(
                        key: ValueKey(result.status),
                        color: color,
                        soft: soft,
                        icon: icon,
                        celebrate: result.status == PaymentStatus.success,
                      ),
                      const SizedBox(height: 28),
                      Text(
                        title,
                        style: t.headlineMedium,
                        textAlign: TextAlign.center,
                      ).animate(key: ValueKey('t${result.status}')).fadeIn(delay: 300.ms).slideY(begin: .3),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        style: t.bodyMedium?.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ).animate(key: ValueKey('m${result.status}')).fadeIn(delay: 400.ms),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            InfoRow(label: 'Amount', value: Fmt.money(result.amount), bold: true),
                            if (request != null) InfoRow(label: 'For', value: request.title.split(' · ').last),
                            InfoRow(label: 'Method', value: result.method.ui.$2),
                            if (result.paymentId != null) InfoRow(label: 'Payment ID', value: result.paymentId!),
                            if (booking != null)
                              InfoRow(label: 'Booking ID', value: booking.code, valueColor: AppColors.primaryGreen),
                            InfoRow(label: 'Date', value: Fmt.date(DateTime.now())),
                          ],
                        ),
                      ).animate().fadeIn(delay: 500.ms).slideY(begin: .1),
                      if (result.status == PaymentStatus.pending) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (state.processing)
                              const SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.warning),
                              )
                            else
                              const LiveDot(color: AppColors.warning),
                            const SizedBox(width: 8),
                            Text(
                              state.processing ? 'Checking with your bank…' : 'Auto-checking status',
                              style: t.bodySmall?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 0, AppSpacing.gutter, 16),
                child: Column(
                  children: switch (result.status) {
                    PaymentStatus.success => [
                      if (booking != null)
                        AppButton(
                          label: 'View QR pass',
                          icon: Icons.qr_code_2_rounded,
                          variant: AppButtonVariant.lime,
                          onPressed: () {
                            ref.read(bookingDraftProvider.notifier).clear();
                            context.go(Routes.bookings);
                            context.push(Routes.pass(booking.id));
                          },
                        ),
                      const SizedBox(height: 10),
                      AppButton(label: 'Back to home', variant: AppButtonVariant.outline, onPressed: _finish),
                    ],
                    PaymentStatus.pending => [
                      AppButton(
                        label: 'Check status now',
                        icon: Icons.refresh_rounded,
                        loading: state.processing,
                        onPressed: _checkPending,
                      ),
                      const SizedBox(height: 10),
                      AppButton(label: 'Back to home', variant: AppButtonVariant.outline, onPressed: _finish),
                    ],
                    PaymentStatus.failed => [
                      AppButton(
                        label: 'Try again',
                        icon: Icons.refresh_rounded,
                        onPressed: () => context.pushReplacement(Routes.checkout),
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                        label: 'Contact support',
                        variant: AppButtonVariant.outline,
                        onPressed: () => context.push(Routes.support),
                      ),
                    ],
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({super.key, required this.color, required this.soft, required this.icon, required this.celebrate});

  final Color color;
  final Color soft;
  final IconData icon;
  final bool celebrate;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (celebrate) const Positioned.fill(child: _Burst()),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(color: soft, shape: BoxShape.circle),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withValues(alpha: .4), blurRadius: 24, offset: const Offset(0, 10))],
            ),
            child: Icon(icon, size: 54, color: Colors.white),
          ).animate().scale(delay: 120.ms, duration: 500.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }
}

/// Confetti-like burst in brand colours.
class _Burst extends StatelessWidget {
  const _Burst();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (_, v, _) => CustomPaint(painter: _BurstPainter(v)),
    );
  }
}

class _BurstPainter extends CustomPainter {
  _BurstPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    const colors = [AppColors.accentLime, AppColors.primaryGreen, AppColors.secondaryDark, AppColors.warning];
    for (var i = 0; i < 18; i++) {
      final angle = i * (2 * math.pi / 18) + (i.isEven ? .1 : -.1);
      final dist = 60 + 45 * t + (i % 3) * 8;
      final p = c + Offset(math.cos(angle), math.sin(angle)) * dist;
      final paint = Paint()..color = colors[i % colors.length].withValues(alpha: (1 - t).clamp(0, 1));
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(angle + t * 3);
      i % 2 == 0
          ? canvas.drawRRect(
              RRect.fromRectAndRadius(const Rect.fromLTWH(-5, -2, 10, 4), const Radius.circular(2)),
              paint,
            )
          : canvas.drawCircle(Offset.zero, 3.5, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.t != t;
}
