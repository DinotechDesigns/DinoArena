import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/brand.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/dinoarena_logo.dart';
import 'router.dart';

class DinoArenaApp extends ConsumerWidget {
  const DinoArenaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: Brand.name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        // Keep layouts intact at very large accessibility font sizes.
        final scaler = mq.textScaler.clamp(minScaleFactor: .9, maxScaleFactor: 1.3);
        return MediaQuery(
          data: mq.copyWith(textScaler: scaler),
          child: ResponsiveFrame(child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
}

/// On tablets / landscape / desktop the phone-first UI is presented in a
/// centred, branded frame instead of being stretched edge to edge.
class ResponsiveFrame extends StatelessWidget {
  const ResponsiveFrame({super.key, required this.child});

  final Widget child;

  static const double maxContentWidth = 520;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    if (mq.size.width <= 700) return child;

    final frameWidth = maxContentWidth;
    final frameHeight = (mq.size.height - 48).clamp(560.0, 960.0);
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        children: [
          const Positioned(left: 40, top: 40, child: DinoArenaWordmark(size: 44, onDark: true, showTagline: true)),
          Center(
            child: Container(
              width: frameWidth,
              height: frameHeight,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 60, offset: Offset(0, 30))],
              ),
              child: MediaQuery(
                data: mq.copyWith(
                  size: Size(frameWidth, frameHeight),
                  padding: EdgeInsets.zero,
                  viewPadding: EdgeInsets.zero,
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
