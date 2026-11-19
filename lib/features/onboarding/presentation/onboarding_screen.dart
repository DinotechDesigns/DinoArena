import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/constants/brand.dart';
import '../../../core/storage/preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/dinoarena_logo.dart';
import '../../../shared/domain/sport_type.dart';
import '../../../shared/widgets/sport_art.dart';

class _Page {
  const _Page(this.kicker, this.title, this.body, this.visual);

  final String kicker;
  final String title;
  final String body;
  final Widget visual;
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = [
    _Page(
      'PLAY.',
      'Three arenas.\nOne app.',
      'A floodlit cricket + football box turf, a dedicated badminton court and two-lane cricket nets — all in one place.',
      _ArenaStackVisual(),
    ),
    _Page(
      'BOOK.',
      'Live slots.\nInstant passes.',
      'See availability update in real time, lock your hour in seconds and walk in with a QR pass.',
      _SlotsVisual(),
    ),
    _Page(
      'COMPETE.',
      'Leagues, cups\n& weekend mixers.',
      'Join daily games and weekend events, or register your team for DinoArena tournaments.',
      _TrophyVisual(),
    ),
  ];

  Future<void> _finish() async {
    await ref.read(appPreferencesProvider).setOnboardingComplete();
    if (mounted) context.go(Routes.login);
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _finish();
    } else {
      _controller.nextPage(duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 12, 12, 0),
                  child: Row(
                    children: [
                      const DinoArenaWordmark(size: 34, onDark: true),
                      const Spacer(),
                      AnimatedOpacity(
                        opacity: _index == _pages.length - 1 ? 0 : 1,
                        duration: const Duration(milliseconds: 250),
                        child: TextButton(
                          onPressed: _finish,
                          child: Text('Skip', style: t.labelLarge?.copyWith(color: Colors.white70)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (i) {
                      HapticFeedback.selectionClick();
                      setState(() => _index = i);
                    },
                    itemBuilder: (context, i) {
                      final p = _pages[i];
                      return LayoutBuilder(
                        builder: (context, c) => SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: c.maxHeight),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: (c.maxHeight * .5).clamp(220, 380),
                                  child: Center(child: p.visual),
                                ),
                                const SizedBox(height: 28),
                                Text(
                                  p.kicker,
                                  style: t.labelLarge?.copyWith(color: AppColors.accentLime, letterSpacing: 3),
                                ).animate(key: ValueKey('k$i')).fadeIn(duration: 400.ms).slideX(begin: -.2),
                                const SizedBox(height: 10),
                                Text(p.title, style: t.displaySmall?.copyWith(color: Colors.white))
                                    .animate(key: ValueKey('t$i'))
                                    .fadeIn(delay: 80.ms, duration: 450.ms)
                                    .slideY(begin: .25, curve: Curves.easeOutCubic),
                                const SizedBox(height: 14),
                                Text(
                                  p.body,
                                  style: t.bodyLarge?.copyWith(color: Colors.white70),
                                ).animate(key: ValueKey('b$i')).fadeIn(delay: 180.ms, duration: 450.ms),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.gutter, 16, AppSpacing.gutter, 20),
                  child: Row(
                    children: [
                      Row(
                        children: List.generate(
                          _pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.only(right: 6),
                            width: i == _index ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: i == _index ? AppColors.accentLime : Colors.white24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 170,
                        child: AppButton(
                          label: _index == _pages.length - 1 ? 'Get started' : 'Next',
                          trailingIcon: Icons.arrow_forward_rounded,
                          variant: AppButtonVariant.lime,
                          onPressed: _next,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(Brand.tagline, style: t.labelSmall?.copyWith(color: Colors.white30, letterSpacing: 3)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArenaStackVisual extends StatelessWidget {
  const _ArenaStackVisual();

  @override
  Widget build(BuildContext context) {
    Widget card(SportType s, String label, double angle, Offset offset, int delay) =>
        Transform.translate(
              offset: offset,
              child: Transform.rotate(
                angle: angle,
                child: SizedBox(
                  width: 210,
                  height: 140,
                  child: SportArt(
                    sport: s,
                    borderRadius: BorderRadius.circular(22),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(s.icon, color: AppColors.accentLime, size: 18),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                label,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(delay: delay.ms, duration: 500.ms)
            .scale(begin: const Offset(.85, .85), curve: Curves.easeOutBack);

    return Stack(
      alignment: Alignment.center,
      children: [
        card(SportType.cricketNets, 'Cricket Nets', .12, const Offset(46, 70), 250),
        card(SportType.badminton, 'Badminton', -.1, const Offset(-44, 0), 150),
        card(SportType.football, 'Box Turf', .03, const Offset(20, -72), 50),
      ],
    );
  }
}

class _SlotsVisual extends StatelessWidget {
  const _SlotsVisual();

  @override
  Widget build(BuildContext context) {
    const labels = ['6 AM', '7 AM', '8 AM', '5 PM', '6 PM', '7 PM', '8 PM', '9 PM', '10 PM'];
    const states = [0, 1, 0, 0, 2, 2, 1, 0, 0]; // 0 open, 1 booked, 2 selected
    return Container(
      width: 290,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.accentLime),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'LIVE AVAILABILITY',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 1.5),
                ),
              ),
              Text('Today', style: TextStyle(color: Colors.white.withValues(alpha: .6), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.1,
            children: [
              for (var i = 0; i < labels.length; i++)
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: switch (states[i]) {
                      2 => AppColors.accentLime,
                      1 => Colors.white.withValues(alpha: .04),
                      _ => Colors.white.withValues(alpha: .1),
                    },
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: states[i] == 2
                          ? AppColors.primaryDark
                          : Colors.white.withValues(alpha: states[i] == 1 ? .3 : .9),
                      decoration: states[i] == 1 ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.white30,
                    ),
                  ),
                ).animate().fadeIn(delay: (60 * i).ms).scale(begin: const Offset(.8, .8), curve: Curves.easeOutBack),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: const Row(
              children: [
                Icon(Icons.qr_code_2_rounded, color: AppColors.primaryDark),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pass ready · 6 PM – 8 PM',
                    style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                  ),
                ),
                Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen),
              ],
            ),
          ).animate().fadeIn(delay: 700.ms).slideY(begin: .4),
        ],
      ),
    );
  }
}

class _TrophyVisual extends StatelessWidget {
  const _TrophyVisual();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        for (final (size, alpha) in [(280.0, .05), (210.0, .08), (140.0, .14)])
          Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentLime.withValues(alpha: alpha),
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(.96, .96),
                end: const Offset(1.04, 1.04),
                duration: 1800.ms,
                curve: Curves.easeInOut,
              ),
        const Icon(Icons.emoji_events_rounded, size: 96, color: AppColors.accentLime)
            .animate()
            .scale(curve: Curves.easeOutBack, duration: 700.ms)
            .then()
            .shimmer(duration: 1400.ms, color: Colors.white),
        Positioned(top: 30, right: 20, child: _chip('₹50K prize pool')),
        Positioned(bottom: 34, left: 10, child: _chip('16 teams')),
      ],
    );
  }

  static Widget _chip(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(100),
      boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 6))],
    ),
    child: Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryDark),
    ),
  ).animate().fadeIn(delay: 400.ms).slideY(begin: .5, curve: Curves.easeOutBack);
}
