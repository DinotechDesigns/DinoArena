import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/config/app_config.dart';
import '../../../core/constants/brand.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/dinoarena_logo.dart';
import '../../../core/widgets/pressable.dart';
import '../../auth/domain/entities/app_user.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../../booking/presentation/providers/booking_providers.dart';
import '../../home/presentation/main_shell.dart';
import '../../notifications/presentation/providers/notification_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _editProfile(BuildContext context, WidgetRef ref, AppUser user) async {
    final name = TextEditingController(text: user.name);
    final email = TextEditingController(text: user.email ?? '');
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          0,
          AppSpacing.gutter,
          AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Edit profile', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline_rounded)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline_rounded)),
            ),
            const SizedBox(height: 20),
            AppButton(label: 'Save changes', onPressed: () => Navigator.pop(context, true)),
          ],
        ),
      ),
    );
    if (saved == true && name.text.trim().length >= 2) {
      await ref.read(authControllerProvider.notifier).updateProfile(name: name.text, email: email.text);
      if (context.mounted) showAppSnack(context, 'Profile updated', icon: Icons.check_circle_rounded);
    }
    name.dispose();
    email.dispose();
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You’ll need your mobile number to log back in to ${Brand.name}.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Stay')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (ok == true) {
      HapticFeedback.mediumImpact();
      await ref.read(authControllerProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final user = ref.watch(authControllerProvider).user;
    final bookings = ref.watch(bookingsControllerProvider).value ?? const [];
    final unread = ref.watch(unreadCountProvider);
    if (user == null) return const SizedBox.shrink();

    final upcoming = bookings.where((b) => b.isUpcoming).length;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              MediaQuery.paddingOf(context).top + 16,
              AppSpacing.gutter,
              26,
            ),
            decoration: const BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadius.xl + 4)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Profile', style: t.headlineMedium?.copyWith(color: Colors.white)),
                    const Spacer(),
                    CircleIconButton(
                      icon: Icons.edit_rounded,
                      tooltip: 'Edit profile',
                      background: Colors.white.withValues(alpha: .1),
                      foreground: Colors.white,
                      onTap: () => _editProfile(context, ref, user),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: AppColors.limeGradient,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: Text(user.initials, style: t.headlineMedium?.copyWith(color: AppColors.primaryDark)),
                    ).animate().scale(curve: Curves.easeOutBack, duration: 500.ms),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: t.titleLarge?.copyWith(color: Colors.white)),
                          const SizedBox(height: 2),
                          Text(
                            '+${user.phone.substring(0, 2)} ${user.phone.substring(2)}',
                            style: t.bodySmall?.copyWith(color: Colors.white60),
                          ),
                          const SizedBox(height: 8),
                          Pill(
                            label: user.tier,
                            icon: Icons.workspace_premium_rounded,
                            color: AppColors.primaryDark,
                            background: AppColors.accentLime,
                            dense: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    _Stat(value: '${user.gamesPlayed}', label: 'Games'),
                    _Stat(value: '${user.hoursPlayed}h', label: 'On court'),
                    _Stat(value: '${user.tournamentsPlayed}', label: 'Tournaments'),
                    _Stat(value: '$upcoming', label: 'Upcoming'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 20, AppSpacing.gutter, 0),
            child: Column(
              children: [
                _MenuGroup(
                  items: [
                    _MenuItem(Icons.confirmation_number_outlined, 'My bookings', () => context.go(Routes.bookings)),
                    _MenuItem(
                      Icons.notifications_none_rounded,
                      'Notifications',
                      () => context.push(Routes.notifications),
                      trailing: unread > 0 ? Pill(label: '$unread new', dense: true) : null,
                    ),
                    _MenuItem(Icons.emoji_events_outlined, 'Tournaments & events', () => context.go(Routes.compete)),
                  ],
                ),
                const SizedBox(height: 14),
                _MenuGroup(
                  items: [
                    _MenuItem(Icons.support_agent_rounded, 'Help & support', () => context.push(Routes.support)),
                    _MenuItem(Icons.info_outline_rounded, 'About ${Brand.name}', () => _about(context)),
                  ],
                ),
                const SizedBox(height: 14),
                _MenuGroup(
                  items: [_MenuItem(Icons.logout_rounded, 'Log out', () => _logout(context, ref), destructive: true)],
                ),
                const SizedBox(height: 28),
                Text(
                  'Member since ${Fmt.monthYear(user.memberSince)}',
                  style: t.bodySmall?.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: kNavClearance),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _about(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        final t = Theme.of(context).textTheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 0, AppSpacing.gutter, AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DinoArenaMark(size: 84),
              const SizedBox(height: 16),
              const DinoArenaWordmark(size: 30, showTagline: true),
              const SizedBox(height: 16),
              Text(
                Brand.description,
                textAlign: TextAlign.center,
                style: t.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Text(
                'Version 1.0.0 · Release 1${AppConfig.useMockData ? ' · Demo data' : ''}',
                style: t.bodySmall?.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text(value, style: t.titleLarge?.copyWith(color: AppColors.accentLime)),
          Text(label, style: t.bodySmall?.copyWith(color: Colors.white60, fontSize: 11)),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.icon, this.label, this.onTap, {this.trailing, this.destructive = false});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool destructive;
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (final (i, item) in items.indexed) ...[
            if (i > 0) const Divider(indent: 64),
            Pressable(
              scale: .99,
              onTap: item.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: item.destructive ? AppColors.errorSoft : AppColors.limeSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        size: 20,
                        color: item.destructive ? AppColors.error : AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.label,
                        style: t.titleSmall?.copyWith(color: item.destructive ? AppColors.error : null),
                      ),
                    ),
                    if (item.trailing != null) ...[item.trailing!, const SizedBox(width: 6)],
                    if (!item.destructive) const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
