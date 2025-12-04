import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_repository/pizza_repository.dart';

import '../blocs/bloc/get_pizza_bloc.dart';
import '../blocs/create_pizza/create_pizza_bloc.dart';
import '../../auth/blocs/sign_in_bloc/sign_in_bloc.dart';

import 'package:pizza_app/screens/home/views/details_screen.dart';
import 'package:pizza_app/screens/home/views/add_product_screen.dart';
import 'package:pizza_app/screens/cart/cart_screen.dart';
import 'package:pizza_app/screens/orders/order_history_screen.dart';
import 'package:pizza_app/screens/home/search/pizza_search_delegate.dart';
import '../../../blocs/cart_bloc/cart_bloc.dart';
import '../../../blocs/order_bloc/order_bloc.dart';
import '../../../blocs/authentication_bloc/authentication_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Image.asset('assets/8.png', scale: 14),
            const SizedBox(width: 8),
            const Text(
              'PIZZA',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
            ),
          ],
        ),
        actions: [
          // Search icon
          BlocBuilder<GetPizzaBloc, GetPizzaState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Tìm kiếm',
                onPressed: state is GetPizzaSuccess
                    ? () async {
                        final result = await showSearch(
                          context: context,
                          delegate: PizzaSearchDelegate(state.pizzas),
                        );
                        if (result != null && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext ctx) => BlocProvider.value(
                                value: context.read<CartBloc>(),
                                child: DetailsScreen(result),
                              ),
                            ),
                          );
                        }
                      }
                    : null,
              );
            },
          ),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final itemCount = state is CartLoaded ? state.cart.itemCount : 0;
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext ctx) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<CartBloc>(),
                              ),
                              BlocProvider.value(
                                value: context.read<OrderBloc>(),
                              ),
                            ],
                            child: const CartScreen(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(CupertinoIcons.cart),
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$itemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          // Admin Menu or Logout only
          if (context.read<AuthenticationBloc>().state.user!.isAdmin)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'Menu',
              onSelected: (String value) async {
                switch (value) {
                  case 'add_product':
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute<bool>(
                        builder: (BuildContext context) => BlocProvider(
                          create: (context) => CreatePizzaBloc(
                            FirebasePizzaRepo(),
                          ),
                          child: const AddProductScreen(),
                        ),
                      ),
                    );
                    if (result == true && context.mounted) {
                      context.read<GetPizzaBloc>().add(GetPizza());
                    }
                    break;
                  case 'order_history':
                    final userId =
                        context.read<AuthenticationBloc>().state.user!.userId;
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext ctx) => BlocProvider.value(
                            value: context.read<OrderBloc>(),
                            child: OrderHistoryScreen(userId: userId),
                          ),
                        ),
                      );
                    }
                    break;
                  case 'logout':
                    context.read<SignInBloc>().add(SignOutRequired());
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'add_product',
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.add_circled),
                      SizedBox(width: 12),
                      Text('Thêm sản phẩm'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'order_history',
                  child: Row(
                    children: [
                      Icon(Icons.receipt_long),
                      SizedBox(width: 12),
                      Text('Lịch sử đơn hàng'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.arrow_right_to_line),
                      SizedBox(width: 12),
                      Text('Đăng xuất'),
                    ],
                  ),
                ),
              ],
            )
          else
            IconButton(
              onPressed: () {
                context.read<SignInBloc>().add(SignOutRequired());
              },
              icon: const Icon(CupertinoIcons.arrow_right_to_line),
              tooltip: 'Đăng xuất',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<GetPizzaBloc, GetPizzaState>(
          builder: (context, state) {
            if (state is GetPizzaSuccess) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 9 / 16,
                ),
                itemCount: state.pizzas.length,
                itemBuilder: (context, i) {
                  return Material(
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext ctx) => BlocProvider.value(
                              value: context.read<CartBloc>(),
                              child: DetailsScreen(state.pizzas[i]),
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(state.pizzas[i].picture),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: state.pizzas[i].isVeg
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Text(
                                          state.pizzas[i].isVeg
                                              ? "VEG"
                                              : "NON-VEG",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green.withAlpha(51),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Text(
                                          state.pizzas[i].spicy == 1
                                              ? "BLAND"
                                              : state.pizzas[i].spicy == 2
                                                  ? "BALANCE"
                                                  : "SPICY",
                                          style: TextStyle(
                                              color: state.pizzas[i].spicy == 1
                                                  ? Colors.green
                                                  : state.pizzas[i].spicy == 2
                                                      ? Colors.orange
                                                      : Colors.red,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  state.pizzas[i].name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  state.pizzas[i].description,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "\$${state.pizzas[i].price - (state.pizzas[i].price * (state.pizzas[i].discount / 100))}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "\$${state.pizzas[i].price}.00",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          CupertinoIcons.add_circled_solid,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Edit & Delete buttons overlay - Admin only
                          if (context
                              .read<AuthenticationBloc>()
                              .state
                              .user!
                              .isAdmin)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Edit button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(77),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      iconSize: 20,
                                      padding: const EdgeInsets.all(8),
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute<bool>(
                                            builder: (BuildContext context) =>
                                                BlocProvider(
                                              create: (context) =>
                                                  CreatePizzaBloc(
                                                FirebasePizzaRepo(),
                                              ),
                                              child: AddProductScreen(
                                                pizzaToEdit: state.pizzas[i],
                                              ),
                                            ),
                                          ),
                                        );
                                        if (result == true && context.mounted) {
                                          context
                                              .read<GetPizzaBloc>()
                                              .add(GetPizza());
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Delete button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(77),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      iconSize: 20,
                                      padding: const EdgeInsets.all(8),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext dialogContext) =>
                                                  AlertDialog(
                                            title: const Text('Xác nhận xóa'),
                                            content: Text(
                                              'Bạn có chắc muốn xóa "${state.pizzas[i].name}"?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    dialogContext),
                                                child: const Text('Hủy'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(dialogContext);
                                                  context
                                                      .read<CreatePizzaBloc>()
                                                      .add(DeletePizza(
                                                        state.pizzas[i].pizzaId,
                                                      ));
                                                  // Refresh list after delete
                                                  Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500),
                                                    () {
                                                      if (context.mounted) {
                                                        context
                                                            .read<
                                                                GetPizzaBloc>()
                                                            .add(GetPizza());
                                                      }
                                                    },
                                                  );
                                                },
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.red,
                                                ),
                                                child: const Text('Xóa'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is GetPizzaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text("An error has occured..."));
            }
          },
        ),
      ),
    );
  }
}
