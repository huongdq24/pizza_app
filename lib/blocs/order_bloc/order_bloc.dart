import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_repository/order_repository.dart';
import 'package:cart_repository/cart_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepo _orderRepo;

  OrderBloc({required OrderRepo orderRepo})
      : _orderRepo = orderRepo,
        super(OrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<LoadUserOrders>(_onLoadUserOrders);
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    emit(OrderPlacing());
    try {
      // Simulate payment processing (2 seconds)
      await Future.delayed(const Duration(seconds: 2));

      // Create order in Firestore
      final order = await _orderRepo.createOrder(
        userId: event.userId,
        cart: event.cart,
        paymentMethod: event.paymentMethod,
        deliveryAddress: event.deliveryAddress,
        notes: event.notes,
      );

      emit(OrderPlaced(order));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onLoadUserOrders(
      LoadUserOrders event, Emitter<OrderState> emit) async {
    emit(UserOrdersLoading());
    try {
      final orders = await _orderRepo.getUserOrders(event.userId);
      emit(UserOrdersLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
