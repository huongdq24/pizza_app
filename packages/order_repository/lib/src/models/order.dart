import 'package:equatable/equatable.dart';
import 'order_item.dart';
import 'order_status.dart';

class Order extends Equatable {
  final String orderId;
  final String userId;
  final List<OrderItem> items;
  final int totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final String paymentMethod;
  final String? deliveryAddress;
  final String? notes;

  const Order({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.paymentMethod,
    this.deliveryAddress,
    this.notes,
  });

  Order copyWith({
    String? orderId,
    String? userId,
    List<OrderItem>? items,
    int? totalAmount,
    OrderStatus? status,
    DateTime? createdAt,
    String? paymentMethod,
    String? deliveryAddress,
    String? notes,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status.toFirestore(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress,
      'notes': notes,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (map['totalAmount'] as num?)?.toInt() ?? 0,
      status: OrderStatus.fromFirestore(map['status'] as String? ?? 'pending'),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['createdAt'] as num?)?.toInt() ??
            DateTime.now().millisecondsSinceEpoch,
      ),
      paymentMethod: map['paymentMethod'] as String? ?? 'cash',
      deliveryAddress: map['deliveryAddress'] as String?,
      notes: map['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        orderId,
        userId,
        items,
        totalAmount,
        status,
        createdAt,
        paymentMethod,
        deliveryAddress,
        notes,
      ];
}
