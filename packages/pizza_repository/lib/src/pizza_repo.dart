import 'models/models.dart';

abstract class PizzaRepo {
  Future<List<Pizza>> getPizzas();
  Future<void> createPizza(Pizza pizza);
  Future<void> updatePizza(Pizza pizza);
  Future<void> deletePizza(String pizzaId);
}
