part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderPlacing extends OrderState {}

class OrderPlaced extends OrderState {
  final Order order;

  const OrderPlaced(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderError extends OrderState {
  final String error;

  const OrderError(this.error);

  @override
  List<Object?> get props => [error];
}

class UserOrdersLoading extends OrderState {}

class UserOrdersLoaded extends OrderState {
  final List<Order> orders;

  const UserOrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}
