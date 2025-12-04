import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String pizzaId;
  final String name;
  final String picture;
  final int price;
  final int quantity;

  const OrderItem({
    required this.pizzaId,
    required this.name,
    required this.picture,
    required this.price,
    required this.quantity,
  });

  int get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'pizzaId': pizzaId,
      'name': name,
      'picture': picture,
      'price': price,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      pizzaId: map['pizzaId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      picture: map['picture'] as String? ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  @override
  List<Object?> get props => [pizzaId, name, picture, price, quantity];
}
