# DinoArena

**PLAY. BOOK. COMPETE.**

DinoArena is a premium multi-sport facility booking platform where customers can discover sports facilities, check available slots, book games, make payments and participate in tournaments.

- App name: **DinoArena** · Package: `com.dinoarena.app`
- Facilities: Cricket + Football Box Turf · Badminton Court · Two-lane Cricket Practice Nets

## Run

```bash
flutter pub get
dart run build_runner build      # only after changing Freezed/JSON models
flutter run                      # Release 1: local mock data + demo payments
```

Open the folder in Android Studio and press Run. Demo login: any valid Indian mobile number, OTP **1234**. On checkout, a *Demo payment mode* switch selects the payment result: Success, Pending or Failure.

Connect the FastAPI backend:

```bash
flutter run --dart-define=USE_MOCK_DATA=false --dart-define=API_BASE_URL=https://api.example.com/api/v1
```

## Features (Release 1)

Splash · 3 onboarding screens · phone login + OTP · profile setup · home dashboard · facility discovery & detail · live slot booking (date strip + month calendar, lanes, peak pricing, real-time updates) · booking summary with coupons (`DINO10`, `PLAY20`) · checkout (UPI / card / net banking / wallet) · payment success / failure / pending · QR booking pass · my bookings (upcoming / past / cancelled, cancellation) · daily & weekend events · tournaments + team registration · notifications · profile · help & support.

## Architecture

Feature-first Clean Architecture:

```
lib/
  app/            app.dart (MaterialApp + responsive frame), router.dart (GoRouter + auth guards)
  core/           config, constants/brand.dart, network (Dio), storage, theme, utils, widgets (logo, buttons…)
  shared/         SportType, mock catalog, SportArt painter, detail widgets
  features/<f>/
    domain/       Freezed entities + repository interfaces
    data/         Mock*Repository (Release 1) + Remote*Repository (Dio/FastAPI)
    presentation/ Riverpod providers + screens + widgets
```

- **State:** Riverpod 3 (`Notifier` / `AsyncNotifier`); `AppConfig.useMockData` selects the mock or remote repository.
- **Navigation:** GoRouter with a `StatefulShellRoute` (bottom nav) and redirects for onboarding, auth and profile setup.
- **Networking:** Dio with a bearer-token interceptor; FastAPI `{"detail": …}` errors are mapped to `ApiException`. Endpoints live in `core/network/api_endpoints.dart`.
- **Payments:** the `PaymentRepository` contract is `createOrder → pay → checkStatus`. `RemotePaymentRepository.pay` is where the gateway SDK will be integrated.
- **Live slots:** `BookingRepository.watchSlots` returns a `Stream`. The mock simulates other players booking. The remote version polls every 15 s and is ready to be swapped for a websocket.

## Brand

- Colours: `#101B18`, `#18372A`, `#268B60`, `#A6F36B`, `#F4F7F2`, `#FFFFFF` (`core/theme/app_colors.dart`).
- Fonts: Plus Jakarta Sans (headings) and Inter (body), bundled in `assets/fonts` (OFL).
- Logo: an italic geometric **D** holding a ball, cut by a speed slash and wrapped by an arena track. The single source is `DinoArenaMarkPainter` in `core/widgets/dinoarena_logo.dart`.
- Regenerate the icon and logo PNGs after changing the logo:

  ```bash
  flutter test tool/generate_brand_assets_test.dart
  dart run flutter_launcher_icons
  ```

## Quality

```bash
flutter analyze
flutter test   # domain, repository, checkout flow, brand consistency, end-to-end onboarding→home
```
