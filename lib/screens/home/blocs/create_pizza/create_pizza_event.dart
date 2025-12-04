part of 'create_pizza_bloc.dart';

sealed class CreatePizzaEvent extends Equatable {
  const CreatePizzaEvent();

  @override
  List<Object> get props => [];
}

class CreatePizza extends CreatePizzaEvent {
  final Pizza pizza;

  const CreatePizza(this.pizza);

  @override
  List<Object> get props => [pizza];
}

class UpdatePizza extends CreatePizzaEvent {
  final Pizza pizza;

  const UpdatePizza(this.pizza);

  @override
  List<Object> get props => [pizza];
}

class DeletePizza extends CreatePizzaEvent {
  final String pizzaId;

  const DeletePizza(this.pizzaId);

  @override
  List<Object> get props => [pizzaId];
}
