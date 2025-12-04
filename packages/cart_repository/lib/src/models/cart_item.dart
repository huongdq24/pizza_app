import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String pizzaId;
  final String name;
  final String picture;
  final int price;
  final int discount;
  final int quantity;

  const CartItem({
    required this.pizzaId,
    required this.name,
    required this.picture,
    required this.price,
    required this.discount,
    this.quantity = 1,
  });

  int get finalPrice => price - (price * discount ~/ 100);
  int get totalPrice => finalPrice * quantity;

  CartItem copyWith({
    String? pizzaId,
    String? name,
    String? picture,
    int? price,
    int? discount,
    int? quantity,
  }) {
    return CartItem(
      pizzaId: pizzaId ?? this.pizzaId,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pizzaId': pizzaId,
      'name': name,
      'picture': picture,
      'price': price,
      'discount': discount,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      pizzaId: map['pizzaId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      picture: map['picture'] as String? ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      discount: (map['discount'] as num?)?.toInt() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  @override
  List<Object?> get props =>
      [pizzaId, name, picture, price, discount, quantity];
}
