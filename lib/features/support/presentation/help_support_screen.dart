import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/brand.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/pressable.dart';
import '../data/support_repository.dart';

class HelpSupportScreen extends ConsumerStatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  ConsumerState<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends ConsumerState<HelpSupportScreen> {
  static const _faqs = [
    (
      'How do I enter the arena?',
      'Open My bookings, tap your booking and show the QR pass at the gate. Staff scan it and you’re in. '
          'Please arrive 10 minutes early.',
    ),
    (
      'What is the cancellation policy?',
      'Slot bookings can be cancelled for free up to 2 hours before the start time. The refund goes back to '
          'your original payment method within 5–7 working days.',
    ),
    (
      'What are peak hours?',
      'Slots from 6 PM onwards on weekdays, and all day on Saturdays and Sundays, are charged at peak rates.',
    ),
    (
      'Can I book both cricket net lanes?',
      'Yes. Book Lane A and Lane B separately for the same hour to get the full two-lane setup for your team.',
    ),
    (
      'My payment is pending — what now?',
      'Your spot is reserved while the bank confirms. Most payments clear within a few minutes; if it fails, '
          'any deducted amount is refunded automatically.',
    ),
    (
      'How do tournament registrations work?',
      'Pick a tournament, enter your team details and pay the entry fee. You’ll get a pass for match days and '
          'fixtures are shared before the tournament begins.',
    ),
  ];

  static const _topics = ['Booking', 'Payment & refund', 'Tournament', 'Facility', 'App issue', 'Other'];

  String _topic = _topics.first;
  final _message = TextEditingController();
  bool _sending = false;

  Future<void> _submit() async {
    if (_message.text.trim().length < 10) {
      showAppSnack(context, 'Tell us a little more (at least 10 characters).', icon: Icons.edit_note_rounded);
      return;
    }
    setState(() => _sending = true);
    try {
      final ref0 = await ref.read(supportRepositoryProvider).submitTicket(topic: _topic, message: _message.text.trim());
      _message.clear();
      if (mounted) {
        FocusScope.of(context).unfocus();
        showAppSnack(
          context,
          'Ticket $ref0 created. We usually reply within 2 hours.',
          icon: Icons.check_circle_rounded,
        );
      }
    } catch (e) {
      if (mounted) showAppSnack(context, e.toString(), icon: Icons.error_outline_rounded);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _copy(String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    showAppSnack(context, '$label copied: $value', icon: Icons.copy_rounded);
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const AppTopBar(title: 'Help & support'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 8, AppSpacing.gutter, 40),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.darkGradient,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const LiveDot(),
                    const SizedBox(width: 6),
                    Text('Support is online', style: t.labelMedium?.copyWith(color: AppColors.accentLime)),
                  ],
                ),
                const SizedBox(height: 10),
                Text('How can we help?', style: t.headlineSmall?.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  'The ${Brand.name} team is here 6 AM – 12 AM, every day.',
                  style: t.bodySmall?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _ContactButton(
                      icon: Icons.call_rounded,
                      label: 'Call',
                      onTap: () => _copy('Phone', Brand.supportPhone),
                    ),
                    const SizedBox(width: 10),
                    _ContactButton(
                      icon: Icons.chat_rounded,
                      label: 'WhatsApp',
                      onTap: () => _copy('WhatsApp', Brand.supportWhatsApp),
                    ),
                    const SizedBox(width: 10),
                    _ContactButton(
                      icon: Icons.mail_rounded,
                      label: 'Email',
                      onTap: () => _copy('Email', Brand.supportEmail),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms).slideY(begin: .08),
          const SizedBox(height: 26),
          Text('Frequently asked', style: t.titleLarge),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (i, (q, a)) in _faqs.indexed) ...[
                  if (i > 0) const Divider(),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      iconColor: AppColors.primaryGreen,
                      collapsedIconColor: AppColors.textMuted,
                      title: Text(q, style: t.titleSmall),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(a, style: t.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 26),
          Text('Raise a ticket', style: t.titleLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final topic in _topics)
                ChoiceChip(
                  label: Text(topic),
                  selected: _topic == topic,
                  showCheckmark: false,
                  labelStyle: t.labelMedium?.copyWith(color: _topic == topic ? Colors.white : AppColors.textPrimary),
                  onSelected: (_) => setState(() => _topic = topic),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _message,
            minLines: 4,
            maxLines: 6,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Describe the issue — include your booking ID if you have one.',
            ),
          ),
          const SizedBox(height: 8),
          AppButton(label: 'Submit ticket', icon: Icons.send_rounded, loading: _sending, onPressed: _submit),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '${Brand.address}\n${Brand.tagline}',
              textAlign: TextAlign.center,
              style: t.bodySmall?.copyWith(color: AppColors.textMuted, height: 1.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Pressable(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.accentLime),
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
