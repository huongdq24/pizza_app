import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';
import 'package:intl/intl.dart';

import '../../blocs/order_bloc/order_bloc.dart';
import '../../blocs/authentication_bloc/authentication_bloc.dart';

class OrdersAdminPage extends StatefulWidget {
  const OrdersAdminPage({super.key});

  @override
  State<OrdersAdminPage> createState() => _OrdersAdminPageState();
}

class _OrdersAdminPageState extends State<OrdersAdminPage> {
  @override
  void initState() {
    super.initState();
    // Load all orders for admin view
    final userId = context.read<AuthenticationBloc>().state.user!.userId;
    context.read<OrderBloc>().add(LoadUserOrders(userId));
  }

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
                  'Order Management',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final userId =
                        context.read<AuthenticationBloc>().state.user!.userId;
                    context.read<OrderBloc>().add(LoadUserOrders(userId));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ),
          // Orders DataTable
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is UserOrdersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserOrdersLoaded) {
                  if (state.orders.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No orders yet'),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Colors.grey.shade200,
                        ),
                        columns: const [
                          DataColumn(label: Text('Order ID')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Items')),
                          DataColumn(label: Text('Total')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: state.orders.map((order) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  '#${order.orderId.substring(0, 8)}...',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  DateFormat('MMM dd, HH:mm')
                                      .format(order.createdAt),
                                ),
                              ),
                              DataCell(
                                Text('${order.items.length} items'),
                              ),
                              DataCell(
                                Text(
                                  '\$${order.totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataCell(
                                Chip(
                                  label: Text(order.status.displayName),
                                  backgroundColor:
                                      _getStatusColor(order.status),
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              DataCell(
                                PopupMenuButton<OrderStatus>(
                                  icon: const Icon(Icons.more_vert),
                                  tooltip: 'Update Status',
                                  onSelected: (OrderStatus newStatus) {
                                    // TODO: Update order status
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Order status updated to ${newStatus.displayName}',
                                        ),
                                      ),
                                    );
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    const PopupMenuItem(
                                      value: OrderStatus.pending,
                                      child: Text('Pending'),
                                    ),
                                    const PopupMenuItem(
                                      value: OrderStatus.confirmed,
                                      child: Text('Confirmed'),
                                    ),
                                    const PopupMenuItem(
                                      value: OrderStatus.preparing,
                                      child: Text('Preparing'),
                                    ),
                                    const PopupMenuItem(
                                      value: OrderStatus.delivered,
                                      child: Text('Delivered'),
                                    ),
                                    const PopupMenuItem(
                                      value: OrderStatus.cancelled,
                                      child: Text('Cancelled'),
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
                } else if (state is OrderError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else {
                  return const Center(child: Text('No orders'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.outForDelivery:
        return Colors.teal;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
