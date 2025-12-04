import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cart_repository/cart_repository.dart';
import '../../blocs/cart_bloc/cart_bloc.dart';
import '../../blocs/authentication_bloc/authentication_bloc.dart';
import '../../blocs/order_bloc/order_bloc.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartError) {
            return Center(
              child: Text('Lỗi: ${state.error}'),
            );
          }

          if (state is CartLoaded) {
            if (state.cart.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Giỏ hàng trống',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.cart.items.length,
                    itemBuilder: (context, index) {
                      final item = state.cart.items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.picture,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey.shade300,
                                      child: const Icon(Icons.error),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${item.finalPrice}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Quantity controls
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (item.quantity > 1) {
                                              context.read<CartBloc>().add(
                                                    UpdateQuantity(
                                                      item.pizzaId,
                                                      item.quantity - 1,
                                                    ),
                                                  );
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.remove_circle_outline),
                                          iconSize: 24,
                                        ),
                                        Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            context.read<CartBloc>().add(
                                                  UpdateQuantity(
                                                    item.pizzaId,
                                                    item.quantity + 1,
                                                  ),
                                                );
                                          },
                                          icon: const Icon(
                                              Icons.add_circle_outline),
                                          iconSize: 24,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Remove button and total
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context.read<CartBloc>().add(
                                            RemoveFromCart(item.pizzaId),
                                          );
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${item.totalPrice}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom total and checkout
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng cộng:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${state.cart.totalPrice}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              final userId = context
                                  .read<AuthenticationBloc>()
                                  .state
                                  .user!
                                  .userId;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext ctx) =>
                                      MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(
                                        value: context.read<CartBloc>(),
                                      ),
                                      BlocProvider.value(
                                        value: context.read<OrderBloc>(),
                                      ),
                                    ],
                                    child: CheckoutScreen(
                                      cart: state.cart,
                                      userId: userId,
                                    ),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Thanh toán (${state.cart.itemCount} món)',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('Đang tải...'));
        },
      ),
    );
  }
}
