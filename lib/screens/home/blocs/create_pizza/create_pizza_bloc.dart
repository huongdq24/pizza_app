import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pizza_repository/pizza_repository.dart';

part 'create_pizza_event.dart';
part 'create_pizza_state.dart';

class CreatePizzaBloc extends Bloc<CreatePizzaEvent, CreatePizzaState> {
  final PizzaRepo _pizzaRepo;

  CreatePizzaBloc(this._pizzaRepo) : super(CreatePizzaInitial()) {
    on<CreatePizza>((event, emit) async {
      emit(CreatePizzaLoading());
      try {
        await _pizzaRepo.createPizza(event.pizza);
        emit(CreatePizzaSuccess());
      } catch (e) {
        emit(CreatePizzaFailure(e.toString()));
      }
    });

    on<UpdatePizza>((event, emit) async {
      emit(CreatePizzaLoading());
      try {
        await _pizzaRepo.updatePizza(event.pizza);
        emit(CreatePizzaSuccess());
      } catch (e) {
        emit(CreatePizzaFailure(e.toString()));
      }
    });

    on<DeletePizza>((event, emit) async {
      emit(CreatePizzaLoading());
      try {
        await _pizzaRepo.deletePizza(event.pizzaId);
        emit(CreatePizzaSuccess());
      } catch (e) {
        emit(CreatePizzaFailure(e.toString()));
      }
    });
  }
}
