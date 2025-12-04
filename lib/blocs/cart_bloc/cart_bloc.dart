import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cart_repository/cart_repository.dart';
import 'package:pizza_repository/pizza_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepo _cartRepo;
  final String userId;

  CartBloc({
    required CartRepo cartRepo,
    required this.userId,
  })  : _cartRepo = cartRepo,
        super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);

    // Auto-load cart when bloc is created
    add(const LoadCart());
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    await emit.forEach<Cart>(
      _cartRepo.cartStream(userId),
      onData: (cart) => CartLoaded(cart),
      onError: (error, stackTrace) => CartError(error.toString()),
    );
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await _cartRepo.addToCart(userId, event.pizza, quantity: event.quantity);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    try {
      await _cartRepo.removeFromCart(userId, event.pizzaId);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateQuantity(
      UpdateQuantity event, Emitter<CartState> emit) async {
    try {
      await _cartRepo.updateQuantity(userId, event.pizzaId, event.quantity);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await _cartRepo.clearCart(userId);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
