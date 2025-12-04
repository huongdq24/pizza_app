import 'models/order.dart';
import 'models/order_status.dart';
import 'package:cart_repository/cart_repository.dart';

abstract class OrderRepo {
  Future<Order> createOrder({
    required String userId,
    required Cart cart,
    required String paymentMethod,
    String? deliveryAddress,
    String? notes,
  });

  Future<List<Order>> getUserOrders(String userId);
  Future<Order> getOrder(String orderId);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
  Stream<List<Order>> userOrdersStream(String userId);
}
