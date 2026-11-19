import '../entities/payment.dart';

/// Lets the demo gateway produce each payment outcome on demand.
enum DemoOutcome { success, failure, pending }

abstract interface class PaymentRepository {
  /// Creates a server-side order (amount in rupees).
  Future<PaymentOrder> createOrder({required int amount, required String description});

  /// Runs the payment for [order] through the gateway.
  Future<PaymentResult> pay(PaymentOrder order, PaymentMethod method, {DemoOutcome demoOutcome = DemoOutcome.success});

  /// Re-checks a pending payment.
  Future<PaymentResult> checkStatus(PaymentResult pending);
}
