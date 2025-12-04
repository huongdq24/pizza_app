import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizza_repository/pizza_repository.dart';

class FirebasePizzaRepo implements PizzaRepo {
  final pizzaCollection = FirebaseFirestore.instance.collection('pizzas');

  @override
  Future<List<Pizza>> getPizzas() async {
    try {
      final pizzas = await pizzaCollection.get().then((value) => value.docs
          .map((e) => Pizza.fromEntity(PizzaEntity.fromDocument(e.data())))
          .toList());

      // Filter out pizzas with invalid picture URLs
      return pizzas
          .where((pizza) =>
              pizza.picture.isNotEmpty &&
              (pizza.picture.startsWith('http://') ||
                  pizza.picture.startsWith('https://')))
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createPizza(Pizza pizza) async {
    try {
      await pizzaCollection
          .doc(pizza.pizzaId)
          .set(pizza.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updatePizza(Pizza pizza) async {
    try {
      await pizzaCollection
          .doc(pizza.pizzaId)
          .update(pizza.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deletePizza(String pizzaId) async {
    try {
      await pizzaCollection.doc(pizzaId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
