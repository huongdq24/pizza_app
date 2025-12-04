import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:cart_repository/cart_repository.dart';
import 'package:uuid/uuid.dart';
import 'order_repo.dart';
import 'models/order.dart';
import 'models/order_item.dart';
import 'models/order_status.dart';

class FirebaseOrderRepo implements OrderRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  CollectionReference get _ordersCollection => _firestore.collection('orders');

  @override
  Future<Order> createOrder({
    required String userId,
    required Cart cart,
    required String paymentMethod,
    String? deliveryAddress,
    String? notes,
  }) async {
    try {
      final orderId = _uuid.v4();

      // Convert cart items to order items
      final orderItems = cart.items.map((cartItem) {
        return OrderItem(
          pizzaId: cartItem.pizzaId,
          name: cartItem.name,
          picture: cartItem.picture,
          price: cartItem.finalPrice,
          quantity: cartItem.quantity,
        );
      }).toList();

      final order = Order(
        orderId: orderId,
        userId: userId,
        items: orderItems,
        totalAmount: cart.totalPrice,
        status: OrderStatus.confirmed,
        createdAt: DateTime.now(),
        paymentMethod: paymentMethod,
        deliveryAddress: deliveryAddress,
        notes: notes,
      );

      await _ordersCollection.doc(orderId).set(order.toMap());
      return order;
    } catch (e) {
      log('Error creating order: $e');
      rethrow;
    }
  }

  @override
  Future<List<Order>> getUserOrders(String userId) async {
    try {
      final snapshot = await _ordersCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Order.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error getting user orders: $e');
      rethrow;
    }
  }

  @override
  Future<Order> getOrder(String orderId) async {
    try {
      final doc = await _ordersCollection.doc(orderId).get();
      if (!doc.exists) {
        throw Exception('Order not found');
      }
      return Order.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      log('Error getting order: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _ordersCollection.doc(orderId).update({
        'status': status.toFirestore(),
      });
    } catch (e) {
      log('Error updating order status: $e');
      rethrow;
    }
  }

  @override
  Stream<List<Order>> userOrdersStream(String userId) {
    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Order.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
