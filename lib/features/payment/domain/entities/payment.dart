import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

enum PaymentMethod {
  @JsonValue('upi')
  upi,
  @JsonValue('card')
  card,
  @JsonValue('netbanking')
  netBanking,
  @JsonValue('wallet')
  wallet,
}

enum PaymentStatus {
  @JsonValue('success')
  success,
  @JsonValue('failed')
  failed,
  @JsonValue('pending')
  pending,
}

@freezed
abstract class LineItem with _$LineItem {
  const factory LineItem({required String label, required int amount}) = _LineItem;

  factory LineItem.fromJson(Map<String, dynamic> json) => _$LineItemFromJson(json);
}

@freezed
abstract class PaymentOrder with _$PaymentOrder {
  const factory PaymentOrder({
    required String orderId,
    required int amount,
    required String currency,
    required String description,
  }) = _PaymentOrder;

  factory PaymentOrder.fromJson(Map<String, dynamic> json) => _$PaymentOrderFromJson(json);
}

@freezed
abstract class PaymentResult with _$PaymentResult {
  const factory PaymentResult({
    required String orderId,
    required PaymentStatus status,
    required int amount,
    required PaymentMethod method,
    String? paymentId,
    String? failureReason,
  }) = _PaymentResult;

  factory PaymentResult.fromJson(Map<String, dynamic> json) => _$PaymentResultFromJson(json);
}
