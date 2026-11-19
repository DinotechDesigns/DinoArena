import 'dart:math';

import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/entities/payment.dart';
import '../domain/repositories/payment_repository.dart';

/// Demo gateway for Release 1. No money moves.
class DemoPaymentRepository implements PaymentRepository {
  final _random = Random();

  String _id(String prefix) =>
      '${prefix}_demo_${List.generate(10, (_) => 'ABCDEFGHJKLMNPQRSTUVWXYZ0123456789'[_random.nextInt(34)]).join()}';

  @override
  Future<PaymentOrder> createOrder({required int amount, required String description}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return PaymentOrder(orderId: _id('order'), amount: amount, currency: 'INR', description: description);
  }

  @override
  Future<PaymentResult> pay(
    PaymentOrder order,
    PaymentMethod method, {
    DemoOutcome demoOutcome = DemoOutcome.success,
  }) async {
    await Future.delayed(const Duration(milliseconds: 2200));
    return switch (demoOutcome) {
      DemoOutcome.success => PaymentResult(
        orderId: order.orderId,
        status: PaymentStatus.success,
        amount: order.amount,
        method: method,
        paymentId: _id('pay'),
      ),
      DemoOutcome.pending => PaymentResult(
        orderId: order.orderId,
        status: PaymentStatus.pending,
        amount: order.amount,
        method: method,
        paymentId: _id('pay'),
      ),
      DemoOutcome.failure => PaymentResult(
        orderId: order.orderId,
        status: PaymentStatus.failed,
        amount: order.amount,
        method: method,
        failureReason: 'The bank declined this transaction. No money was deducted.',
      ),
    };
  }

  @override
  Future<PaymentResult> checkStatus(PaymentResult pending) async {
    await Future.delayed(const Duration(milliseconds: 1800));
    return pending.copyWith(status: PaymentStatus.success);
  }
}

/// FastAPI-backed payments. The backend creates the gateway order; the client
/// SDK (e.g. Razorpay / Cashfree / PhonePe PG) collects payment; the backend
/// verifies the signature and returns the final status.
class RemotePaymentRepository implements PaymentRepository {
  RemotePaymentRepository(this._dio);

  final Dio _dio;

  @override
  Future<PaymentOrder> createOrder({required int amount, required String description}) => guardApi(() async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.createPaymentOrder,
      data: {'amount': amount, 'currency': 'INR', 'description': description},
    );
    return PaymentOrder.fromJson(res.data!);
  });

  @override
  Future<PaymentResult> pay(PaymentOrder order, PaymentMethod method, {DemoOutcome demoOutcome = DemoOutcome.success}) {
    // Integration point: launch the gateway SDK with order.orderId, then call checkStatus.
    throw const ApiException('Payment gateway SDK is not configured for this build.');
  }

  @override
  Future<PaymentResult> checkStatus(PaymentResult pending) => guardApi(() async {
    final res = await _dio.get<Map<String, dynamic>>(ApiEndpoints.paymentStatus(pending.orderId));
    return PaymentResult.fromJson(res.data!);
  });
}
