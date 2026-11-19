import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/storage/preferences.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/auth/presentation/screens/profile_setup_screen.dart';
import '../features/booking/presentation/screens/booking_pass_screen.dart';
import '../features/booking/presentation/screens/booking_summary_screen.dart';
import '../features/booking/presentation/screens/my_bookings_screen.dart';
import '../features/booking/presentation/screens/slot_booking_screen.dart';
import '../features/events/presentation/screens/compete_screen.dart';
import '../features/events/presentation/screens/event_detail_screen.dart';
import '../features/facilities/presentation/screens/explore_screen.dart';
import '../features/facilities/presentation/screens/facility_detail_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/home/presentation/main_shell.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/payment/presentation/screens/checkout_screen.dart';
import '../features/payment/presentation/screens/payment_result_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/support/presentation/help_support_screen.dart';
import '../features/tournaments/presentation/screens/tournament_detail_screen.dart';
import '../features/tournaments/presentation/screens/tournament_register_screen.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const otp = '/otp';
  static const setup = '/setup';
  static const home = '/home';
  static const explore = '/explore';
  static const bookings = '/bookings';
  static const compete = '/compete';
  static const profile = '/profile';
  static const bookingSummary = '/booking-summary';
  static const checkout = '/checkout';
  static const paymentResult = '/payment-result';
  static const notifications = '/notifications';
  static const support = '/support';

  static String facility(String id) => '/facility/$id';
  static String book(String facilityId) => '/book/$facilityId';
  static String pass(String bookingId) => '/pass/$bookingId';
  static String event(String id) => '/event/$id';
  static String tournament(String id) => '/tournament/$id';
  static String tournamentRegister(String id) => '/tournament/$id/register';

  static const _public = {onboarding, login, otp};
}

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) => CustomTransitionPage<void>(
  key: state.pageKey,
  child: child,
  transitionDuration: const Duration(milliseconds: 450),
  transitionsBuilder: (context, animation, _, child) => FadeTransition(
    opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
    child: child,
  ),
);

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(authControllerProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      if (loc == Routes.splash) return null;
      final auth = ref.read(authControllerProvider);
      final prefs = ref.read(appPreferencesProvider);

      if (!auth.isAuthenticated) {
        if (Routes._public.contains(loc)) return null;
        return prefs.onboardingComplete ? Routes.login : Routes.onboarding;
      }
      if (auth.needsProfile) return loc == Routes.setup ? null : Routes.setup;
      if (Routes._public.contains(loc) || loc == Routes.setup) return Routes.home;
      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, pageBuilder: (_, s) => _fadePage(s, const SplashScreen())),
      GoRoute(path: Routes.onboarding, pageBuilder: (_, s) => _fadePage(s, const OnboardingScreen())),
      GoRoute(path: Routes.login, pageBuilder: (_, s) => _fadePage(s, const LoginScreen())),
      GoRoute(
        path: Routes.otp,
        builder: (_, s) => OtpScreen(phone: s.extra as String? ?? ''),
      ),
      GoRoute(path: Routes.setup, pageBuilder: (_, s) => _fadePage(s, const ProfileSetupScreen())),
      StatefulShellRoute.indexedStack(
        pageBuilder: (_, s, shell) => _fadePage(s, MainShell(shell: shell)),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.explore, builder: (_, _) => const ExploreScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.bookings, builder: (_, _) => const MyBookingsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.compete, builder: (_, _) => const CompeteScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.profile, builder: (_, _) => const ProfileScreen())],
          ),
        ],
      ),
      GoRoute(
        path: '/facility/:id',
        builder: (_, s) => FacilityDetailScreen(facilityId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/book/:id',
        builder: (_, s) => SlotBookingScreen(facilityId: s.pathParameters['id']!),
      ),
      GoRoute(path: Routes.bookingSummary, builder: (_, _) => const BookingSummaryScreen()),
      GoRoute(path: Routes.checkout, builder: (_, _) => const CheckoutScreen()),
      GoRoute(path: Routes.paymentResult, pageBuilder: (_, s) => _fadePage(s, const PaymentResultScreen())),
      GoRoute(
        path: '/pass/:id',
        builder: (_, s) => BookingPassScreen(bookingId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/event/:id',
        builder: (_, s) => EventDetailScreen(eventId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/tournament/:id',
        builder: (_, s) => TournamentDetailScreen(tournamentId: s.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'register',
            builder: (_, s) => TournamentRegisterScreen(tournamentId: s.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(path: Routes.notifications, builder: (_, _) => const NotificationsScreen()),
      GoRoute(path: Routes.support, builder: (_, _) => const HelpSupportScreen()),
    ],
  );
});
