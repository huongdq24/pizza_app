import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class Cart extends Equatable {
  final String userId;
  final List<CartItem> items;
  final DateTime updatedAt;

  const Cart({
    required this.userId,
    required this.items,
    required this.updatedAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice => items.fold(0, (sum, item) => sum + item.totalPrice);

  Cart copyWith({
    String? userId,
    List<CartItem>? items,
    DateTime? updatedAt,
  }) {
    return Cart(
      userId: userId ?? this.userId,
      items: items ?? this.items,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'total': totalPrice,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map, String userId) {
    return Cart(
      userId: userId,
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (map['updatedAt'] as num?)?.toInt() ??
            DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  factory Cart.empty(String userId) {
    return Cart(
      userId: userId,
      items: [],
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [userId, items, updatedAt];
}
