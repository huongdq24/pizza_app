import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_repository/pizza_repository.dart';

import '../home/blocs/bloc/get_pizza_bloc.dart';
import '../home/blocs/create_pizza/create_pizza_bloc.dart';
import '../home/views/add_product_screen.dart';

class ProductsAdminPage extends StatelessWidget {
  const ProductsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Product Management',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
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
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Products DataTable
          Expanded(
            child: BlocBuilder<GetPizzaBloc, GetPizzaState>(
              builder: (context, state) {
                if (state is GetPizzaLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetPizzaSuccess) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Colors.grey.shade200,
                        ),
                        columns: const [
                          DataColumn(label: Text('Image')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Discount')),
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('Spicy')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: state.pizzas.map((pizza) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Image.network(
                                  pizza.picture,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                              ),
                              DataCell(Text(pizza.name)),
                              DataCell(Text('\$${pizza.price}')),
                              DataCell(Text('${pizza.discount}%')),
                              DataCell(
                                Text(pizza.isVeg ? 'Veg' : 'Non-Veg'),
                              ),
                              DataCell(
                                Text(
                                  pizza.spicy == 1
                                      ? 'Bland'
                                      : pizza.spicy == 2
                                          ? 'Balance'
                                          : 'Spicy',
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      tooltip: 'Edit',
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
                                                pizzaToEdit: pizza,
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
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      tooltip: 'Delete',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext dialogContext) =>
                                                  AlertDialog(
                                            title: const Text('Confirm Delete'),
                                            content: Text(
                                              'Delete "${pizza.name}"?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    dialogContext),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(dialogContext);
                                                  context
                                                      .read<CreatePizzaBloc>()
                                                      .add(DeletePizza(
                                                          pizza.pizzaId));
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
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('Error loading products'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
