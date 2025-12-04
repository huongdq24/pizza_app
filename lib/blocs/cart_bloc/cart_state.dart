part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}

class CartError extends CartState {
  final String error;

  const CartError(this.error);

  @override
  List<Object?> get props => [error];
}
