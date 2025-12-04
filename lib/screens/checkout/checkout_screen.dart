import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cart_repository/cart_repository.dart';
import 'package:order_repository/order_repository.dart';
import '../../blocs/order_bloc/order_bloc.dart';
import '../../blocs/cart_bloc/cart_bloc.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final Cart cart;
  final String userId;

  const CheckoutScreen({
    required this.cart,
    required this.userId,
    super.key,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'cash';
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          'Thanh toán',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderPlaced) {
            // Clear cart after successful order
            context.read<CartBloc>().add(const ClearCart());

            // Navigate to confirmation
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OrderConfirmationScreen(order: state.order),
              ),
            );
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            final isProcessing = state is OrderPlacing;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary
                    const Text(
                      'Đơn hàng',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ...widget.cart.items.map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${item.name} x${item.quantity}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Text(
                                        '\$${item.totalPrice}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            const Divider(),
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
                                  '\$${widget.cart.totalPrice}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Payment Method
                    const Text(
                      'Phương thức thanh toán',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Column(
                        children: [
                          RadioListTile(
                            title: const Text('Tiền mặt khi nhận hàng'),
                            value: 'cash',
                            groupValue: _selectedPayment,
                            onChanged: isProcessing
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedPayment = value.toString();
                                    });
                                  },
                          ),
                          RadioListTile(
                            title: const Text('Thẻ (Mock)'),
                            value: 'card',
                            groupValue: _selectedPayment,
                            onChanged: isProcessing
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedPayment = value.toString();
                                    });
                                  },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Delivery Address
                    const Text(
                      'Địa chỉ giao hàng',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _addressController,
                      enabled: !isProcessing,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Nhập địa chỉ giao hàng...',
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 24),

                    // Notes
                    const Text(
                      'Ghi chú',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      enabled: !isProcessing,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Ghi chú cho đơn hàng (tùy chọn)...',
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 32),

                    // Place Order Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isProcessing
                            ? null
                            : () {
                                if (_addressController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Vui lòng nhập địa chỉ giao hàng'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                context.read<OrderBloc>().add(PlaceOrder(
                                      userId: widget.userId,
                                      cart: widget.cart,
                                      paymentMethod: _selectedPayment,
                                      deliveryAddress:
                                          _addressController.text.trim(),
                                      notes: _notesController.text
                                              .trim()
                                              .isNotEmpty
                                          ? _notesController.text.trim()
                                          : null,
                                    ));
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isProcessing
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Đặt hàng',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
