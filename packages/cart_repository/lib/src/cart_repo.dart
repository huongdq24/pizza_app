import 'models/cart.dart';
import 'models/cart_item.dart';
import 'package:pizza_repository/pizza_repository.dart';

abstract class CartRepo {
  Future<Cart> getCart(String userId);
  Future<void> addToCart(String userId, Pizza pizza, {int quantity = 1});
  Future<void> removeFromCart(String userId, String pizzaId);
  Future<void> updateQuantity(String userId, String pizzaId, int quantity);
  Future<void> clearCart(String userId);
  Stream<Cart> cartStream(String userId);
}
