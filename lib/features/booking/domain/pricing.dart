/// Pure pricing rules shared by the booking summary and checkout.
class PriceBreakdown {
  const PriceBreakdown({required this.subtotal, required this.discount, required this.tax, this.couponCode});

  static const double gstRate = .18;

  /// Demo coupons. The backend will own this list in production.
  static const Map<String, double> coupons = {'DINO10': .10, 'PLAY20': .20};
  static const int maxDiscount = 300;

  factory PriceBreakdown.calculate(int subtotal, {String? coupon}) {
    final code = coupon?.trim().toUpperCase();
    final rate = code == null ? null : coupons[code];
    final discount = rate == null ? 0 : (subtotal * rate).round().clamp(0, maxDiscount);
    final taxable = subtotal - discount;
    return PriceBreakdown(
      subtotal: subtotal,
      discount: discount,
      tax: (taxable * gstRate).round(),
      couponCode: rate == null ? null : code,
    );
  }

  final int subtotal;
  final int discount;
  final int tax;
  final String? couponCode;

  int get total => subtotal - discount + tax;
}
