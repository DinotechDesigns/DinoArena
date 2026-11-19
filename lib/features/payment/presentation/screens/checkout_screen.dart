import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/brand.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/dinoarena_logo.dart';
import '../../../../core/widgets/pressable.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../providers/checkout_providers.dart';

extension PaymentMethodUi on PaymentMethod {
  (IconData, String, String) get ui => switch (this) {
    PaymentMethod.upi => (Icons.qr_code_scanner_rounded, 'UPI', 'GPay, PhonePe, Paytm & more'),
    PaymentMethod.card => (Icons.credit_card_rounded, 'Credit / Debit card', 'Visa, Mastercard, RuPay'),
    PaymentMethod.netBanking => (Icons.account_balance_rounded, 'Net banking', 'All major banks'),
    PaymentMethod.wallet => (Icons.account_balance_wallet_rounded, 'Wallets', 'Paytm, Amazon Pay, Mobikwik'),
  };
}

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  Future<void> _pay(BuildContext context, WidgetRef ref) async {
    HapticFeedback.mediumImpact();
    await ref.read(checkoutControllerProvider.notifier).pay();
    if (context.mounted) context.pushReplacement(Routes.paymentResult);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final state = ref.watch(checkoutControllerProvider);
    final request = state.request;

    if (request == null) {
      return Scaffold(
        appBar: const AppTopBar(title: 'Checkout'),
        body: EmptyState(
          icon: Icons.shopping_bag_outlined,
          title: 'Nothing to pay for',
          message: 'Your checkout session has expired.',
          actionLabel: 'Go home',
          onAction: () => context.go(Routes.home),
        ),
      );
    }

    return PopScope(
      canPop: !state.processing,
      child: Stack(
        children: [
          Scaffold(
            appBar: const AppTopBar(title: 'Checkout'),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 8, AppSpacing.gutter, 140),
              children: [
                // Order card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AppColors.darkGradient,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const DinoArenaMark(size: 30, withBackground: false),
                          const SizedBox(width: 8),
                          Text('${Brand.name} order', style: t.labelMedium?.copyWith(color: Colors.white70)),
                          const Spacer(),
                          const Icon(Icons.lock_rounded, color: AppColors.accentLime, size: 16),
                          const SizedBox(width: 4),
                          Text('Secure', style: t.labelSmall?.copyWith(color: AppColors.accentLime)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(request.title, style: t.titleLarge?.copyWith(color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(request.subtitle, style: t.bodySmall?.copyWith(color: Colors.white70)),
                      const SizedBox(height: 16),
                      for (final item in request.lineItems)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(item.label, style: t.bodyMedium?.copyWith(color: Colors.white70)),
                              ),
                              Text(
                                item.amount < 0 ? '– ${Fmt.money(-item.amount)}' : Fmt.money(item.amount),
                                style: t.labelLarge?.copyWith(
                                  color: item.amount < 0 ? AppColors.accentLime : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: DashedLine(color: Colors.white24),
                      ),
                      Row(
                        children: [
                          Text('Total', style: t.titleMedium?.copyWith(color: Colors.white)),
                          const Spacer(),
                          Text(Fmt.money(request.total), style: t.headlineSmall?.copyWith(color: AppColors.accentLime)),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 350.ms).slideY(begin: .08),
                const SizedBox(height: 24),
                Text('Pay with', style: t.titleLarge),
                const SizedBox(height: 12),
                for (final (i, m) in PaymentMethod.values.indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _MethodTile(
                      method: m,
                      selected: state.method == m,
                      onTap: () => ref.read(checkoutControllerProvider.notifier).selectMethod(m),
                    ).animate().fadeIn(delay: (60 * i).ms).slideX(begin: .06),
                  ),
                if (AppConfig.useMockData) ...[
                  const SizedBox(height: 14),
                  _DemoOutcomePicker(
                    value: state.demoOutcome,
                    onChanged: ref.read(checkoutControllerProvider.notifier).setDemoOutcome,
                  ),
                ],
              ],
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                14,
                AppSpacing.gutter,
                14 + MediaQuery.paddingOf(context).bottom,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    label: 'Pay ${Fmt.money(request.total)}',
                    icon: Icons.lock_rounded,
                    variant: AppButtonVariant.green,
                    loading: state.processing,
                    onPressed: () => _pay(context, ref),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '100% secure payments · PCI-DSS compliant gateway',
                    style: t.bodySmall?.copyWith(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          if (state.processing) const _ProcessingOverlay(),
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({required this.method, required this.selected, required this.onTap});

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final (icon, title, subtitle) = method.ui;
    return Semantics(
      selected: selected,
      button: true,
      child: Pressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? AppColors.limeSoft : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md + 2),
            border: Border.all(color: selected ? AppColors.primaryGreen : AppColors.border, width: selected ? 1.6 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryGreen : AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: selected ? Colors.white : AppColors.textSecondary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: t.titleSmall),
                    Text(subtitle, style: t.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.primaryGreen : Colors.transparent,
                  border: Border.all(color: selected ? AppColors.primaryGreen : AppColors.border, width: 2),
                ),
                child: selected ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoOutcomePicker extends StatelessWidget {
  const _DemoOutcomePicker({required this.value, required this.onChanged});

  final DemoOutcome value;
  final ValueChanged<DemoOutcome> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warningSoft,
        borderRadius: BorderRadius.circular(AppRadius.md + 2),
        border: Border.all(color: AppColors.warning.withValues(alpha: .4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.science_rounded, size: 18, color: AppColors.warning),
              const SizedBox(width: 8),
              Text('Demo payment mode', style: t.titleSmall),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'No money moves in Release 1. Choose the result the demo gateway should return.',
            style: t.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          SegmentedButton<DemoOutcome>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: AppColors.primaryDark,
              selectedForegroundColor: Colors.white,
              backgroundColor: AppColors.surface,
            ),
            segments: const [
              ButtonSegment(value: DemoOutcome.success, label: Text('Success'), icon: Icon(Icons.check_rounded)),
              ButtonSegment(
                value: DemoOutcome.pending,
                label: Text('Pending'),
                icon: Icon(Icons.hourglass_top_rounded),
              ),
              ButtonSegment(value: DemoOutcome.failure, label: Text('Failure'), icon: Icon(Icons.close_rounded)),
            ],
            selected: {value},
            onSelectionChanged: (s) => onChanged(s.first),
          ),
        ],
      ),
    );
  }
}

class _ProcessingOverlay extends StatelessWidget {
  const _ProcessingOverlay();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.primaryDark.withValues(alpha: .92),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox.square(
                    dimension: 112,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.accentLime,
                      backgroundColor: Colors.white10,
                    ),
                  ),
                  const DinoArenaMark(size: 64, withBackground: false)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(.92, .92), end: const Offset(1.04, 1.04), duration: 700.ms),
                ],
              ),
              const SizedBox(height: 28),
              Text('Processing payment', style: t.titleLarge?.copyWith(color: Colors.white)),
              const SizedBox(height: 6),
              Text('Please don’t close the app or press back', style: t.bodySmall?.copyWith(color: Colors.white60)),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 250.ms),
    );
  }
}
