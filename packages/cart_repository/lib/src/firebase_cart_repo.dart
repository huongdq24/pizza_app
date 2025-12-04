import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizza_repository/pizza_repository.dart';
import 'cart_repo.dart';
import 'models/cart.dart';
import 'models/cart_item.dart';

class FirebaseCartRepo implements CartRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _cartsCollection => _firestore.collection('carts');

  @override
  Future<Cart> getCart(String userId) async {
    try {
      final doc = await _cartsCollection.doc(userId).get();
      if (doc.exists) {
        return Cart.fromMap(doc.data() as Map<String, dynamic>, userId);
      }
      return Cart.empty(userId);
    } catch (e) {
      log('Error getting cart: $e');
      rethrow;
    }
  }

  @override
  Future<void> addToCart(String userId, Pizza pizza, {int quantity = 1}) async {
    try {
      final cart = await getCart(userId);
      final existingItemIndex =
          cart.items.indexWhere((item) => item.pizzaId == pizza.pizzaId);

      List<CartItem> updatedItems;
      if (existingItemIndex >= 0) {
        // Update existing item
        updatedItems = List.from(cart.items);
        updatedItems[existingItemIndex] =
            updatedItems[existingItemIndex].copyWith(
          quantity: updatedItems[existingItemIndex].quantity + quantity,
        );
      } else {
        // Add new item
        updatedItems = [
          ...cart.items,
          CartItem(
            pizzaId: pizza.pizzaId,
            name: pizza.name,
            picture: pizza.picture,
            price: pizza.price,
            discount: pizza.discount,
            quantity: quantity,
          ),
        ];
      }

      final updatedCart = cart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );

      await _cartsCollection.doc(userId).set(updatedCart.toMap());
    } catch (e) {
      log('Error adding to cart: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeFromCart(String userId, String pizzaId) async {
    try {
      final cart = await getCart(userId);
      final updatedItems =
          cart.items.where((item) => item.pizzaId != pizzaId).toList();

      final updatedCart = cart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );

      await _cartsCollection.doc(userId).set(updatedCart.toMap());
    } catch (e) {
      log('Error removing from cart: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateQuantity(
      String userId, String pizzaId, int quantity) async {
    try {
      if (quantity <= 0) {
        await removeFromCart(userId, pizzaId);
        return;
      }

      final cart = await getCart(userId);
      final updatedItems = cart.items.map((item) {
        if (item.pizzaId == pizzaId) {
          return item.copyWith(quantity: quantity);
        }
        return item;
      }).toList();

      final updatedCart = cart.copyWith(
        items: updatedItems,
        updatedAt: DateTime.now(),
      );

      await _cartsCollection.doc(userId).set(updatedCart.toMap());
    } catch (e) {
      log('Error updating quantity: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearCart(String userId) async {
    try {
      await _cartsCollection.doc(userId).delete();
    } catch (e) {
      log('Error clearing cart: $e');
      rethrow;
    }
  }

  @override
  Stream<Cart> cartStream(String userId) {
    return _cartsCollection.doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Cart.fromMap(snapshot.data() as Map<String, dynamic>, userId);
      }
      return Cart.empty(userId);
    });
  }
}
