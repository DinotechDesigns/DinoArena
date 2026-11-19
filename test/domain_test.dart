import 'package:dinoarena/features/auth/domain/entities/app_user.dart';
import 'package:dinoarena/features/booking/domain/pricing.dart';
import 'package:dinoarena/shared/data/mock_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PriceBreakdown', () {
    test('adds 18% GST with no coupon', () {
      final p = PriceBreakdown.calculate(3200);
      expect(p.discount, 0);
      expect(p.tax, 576);
      expect(p.total, 3776);
      expect(p.couponCode, isNull);
    });

    test('applies DINO10 case-insensitively before tax', () {
      final p = PriceBreakdown.calculate(1200, coupon: ' dino10 ');
      expect(p.couponCode, 'DINO10');
      expect(p.discount, 120);
      expect(p.tax, ((1200 - 120) * .18).round());
      expect(p.total, 1080 + 194);
    });

    test('caps discount at maxDiscount', () {
      final p = PriceBreakdown.calculate(6400, coupon: 'PLAY20');
      expect(p.discount, PriceBreakdown.maxDiscount);
    });

    test('ignores unknown coupons', () {
      final p = PriceBreakdown.calculate(500, coupon: 'NOPE');
      expect(p.discount, 0);
      expect(p.couponCode, isNull);
    });
  });

  group('Facility pricing', () {
    final turf = MockCatalog.facilities.firstWhere((f) => f.id == 'box-turf');

    test('weekday daytime is off-peak', () {
      final wednesday10am = DateTime(2026, 11, 18, 10);
      expect(turf.isPeak(wednesday10am), isFalse);
      expect(turf.priceFor(wednesday10am), turf.pricePerHour);
    });

    test('evenings and weekends are peak', () {
      expect(turf.isPeak(DateTime(2026, 11, 18, 19)), isTrue);
      expect(turf.priceFor(DateTime(2026, 11, 21, 9)), turf.peakPricePerHour);
    });
  });

  test('catalog covers the three DinoArena facilities', () {
    final kinds = MockCatalog.facilities.map((f) => f.headline).toList();
    expect(kinds, contains('Cricket + Football Box Turf'));
    expect(kinds, contains('Indoor Badminton Court'));
    expect(kinds, contains('Two-lane Cricket Practice Nets'));
    expect(MockCatalog.facilities.firstWhere((f) => f.id == 'practice-nets').units, 2);
  });

  test('AppUser derives initials, first name and tier', () {
    final u = AppUser(id: '1', phone: '919876543210', name: 'arjun mehta', memberSince: DateTime(2026), gamesPlayed: 12);
    expect(u.initials, 'AM');
    expect(u.firstName, 'arjun');
    expect(u.tier, 'Arena Pro');
    expect(AppUser.fromJson(u.toJson()), u);
  });
}
