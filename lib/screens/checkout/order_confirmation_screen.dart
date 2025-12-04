import 'package:flutter/material.dart';
import 'package:order_repository/order_repository.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final Order order;

  const OrderConfirmationScreen({
    required this.order,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.green.shade600,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Đặt hàng thành công!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  'Cảm ơn bạn đã đặt hàng',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 32),

                // Order Details Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chi tiết đơn hàng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          'Mã đơn hàng',
                          order.orderId.substring(0, 8).toUpperCase(),
                        ),
                        _buildDetailRow(
                          'Số món',
                          '${order.items.length} món',
                        ),
                        _buildDetailRow(
                          'Tổng tiền',
                          '\$${order.totalAmount}',
                          valueColor: Colors.green,
                          valueBold: true,
                        ),
                        _buildDetailRow(
                          'Thanh toán',
                          order.paymentMethod == 'cash' ? 'Tiền mặt' : 'Thẻ',
                        ),
                        if (order.deliveryAddress != null)
                          _buildDetailRow(
                            'Địa chỉ',
                            order.deliveryAddress!,
                          ),
                        _buildDetailRow(
                          'Trạng thái',
                          order.status.displayName,
                          valueColor: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Estimated Delivery
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delivery_dining,
                        color: Colors.blue.shade700,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thời gian giao hàng dự kiến',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '30-45 phút',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Back to Home Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Về trang chủ',
                      style: TextStyle(
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
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
