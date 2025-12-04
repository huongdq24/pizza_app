part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class AddToCart extends CartEvent {
  final Pizza pizza;
  final int quantity;

  const AddToCart(this.pizza, {this.quantity = 1});

  @override
  List<Object?> get props => [pizza, quantity];
}

class RemoveFromCart extends CartEvent {
  final String pizzaId;

  const RemoveFromCart(this.pizzaId);

  @override
  List<Object?> get props => [pizzaId];
}

class UpdateQuantity extends CartEvent {
  final String pizzaId;
  final int quantity;

  const UpdateQuantity(this.pizzaId, this.quantity);

  @override
  List<Object?> get props => [pizzaId, quantity];
}

class ClearCart extends CartEvent {
  const ClearCart();
}
