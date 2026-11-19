/// Single source of truth for DinoArena brand copy.
///
/// Every user-facing mention of the brand must come from here so the name,
/// tagline and descriptions stay consistent across the app.
abstract final class Brand {
  static const String name = 'DinoArena';
  static const String nameFirst = 'Dino';
  static const String nameSecond = 'Arena';
  static const String packageName = 'com.dinoarena.app';
  static const String tagline = 'PLAY. BOOK. COMPETE.';
  static const List<String> taglineWords = ['PLAY.', 'BOOK.', 'COMPETE.'];
  static const String description =
      'DinoArena is a premium multi-sport facility booking platform where '
      'you can discover sports facilities, check available slots, book games, '
      'make payments and participate in tournaments.';

  static const String supportPhone = '+91 98765 43210';
  static const String supportEmail = 'support@dinoarena.app';
  static const String supportWhatsApp = '+91 98765 43210';
  static const String address = 'DinoArena Sports Hub, Main Road, Your City';
  static const String passPrefix = 'DINO';
}
