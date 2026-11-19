// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LineItem _$LineItemFromJson(Map<String, dynamic> json) =>
    _LineItem(label: json['label'] as String, amount: (json['amount'] as num).toInt());

Map<String, dynamic> _$LineItemToJson(_LineItem instance) => <String, dynamic>{
  'label': instance.label,
  'amount': instance.amount,
};

_PaymentOrder _$PaymentOrderFromJson(Map<String, dynamic> json) => _PaymentOrder(
  orderId: json['order_id'] as String,
  amount: (json['amount'] as num).toInt(),
  currency: json['currency'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$PaymentOrderToJson(_PaymentOrder instance) => <String, dynamic>{
  'order_id': instance.orderId,
  'amount': instance.amount,
  'currency': instance.currency,
  'description': instance.description,
};

_PaymentResult _$PaymentResultFromJson(Map<String, dynamic> json) => _PaymentResult(
  orderId: json['order_id'] as String,
  status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
  amount: (json['amount'] as num).toInt(),
  method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
  paymentId: json['payment_id'] as String?,
  failureReason: json['failure_reason'] as String?,
);

Map<String, dynamic> _$PaymentResultToJson(_PaymentResult instance) => <String, dynamic>{
  'order_id': instance.orderId,
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'amount': instance.amount,
  'method': _$PaymentMethodEnumMap[instance.method]!,
  'payment_id': ?instance.paymentId,
  'failure_reason': ?instance.failureReason,
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.success: 'success',
  PaymentStatus.failed: 'failed',
  PaymentStatus.pending: 'pending',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.upi: 'upi',
  PaymentMethod.card: 'card',
  PaymentMethod.netBanking: 'netbanking',
  PaymentMethod.wallet: 'wallet',
};
