part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class PlaceOrder extends OrderEvent {
  final String userId;
  final Cart cart;
  final String paymentMethod;
  final String? deliveryAddress;
  final String? notes;

  const PlaceOrder({
    required this.userId,
    required this.cart,
    required this.paymentMethod,
    this.deliveryAddress,
    this.notes,
  });

  @override
  List<Object?> get props =>
      [userId, cart, paymentMethod, deliveryAddress, notes];
}

class LoadUserOrders extends OrderEvent {
  final String userId;

  const LoadUserOrders(this.userId);

  @override
  List<Object?> get props => [userId];
}
