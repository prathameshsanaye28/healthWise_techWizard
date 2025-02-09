import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/patient_base/models/cart_models.dart';
import 'package:intl/intl.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final Order order;

  const OrderConfirmationScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Order Placed Successfully!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Text(
              'Order ID: ${order.id}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Order Date: ${DateFormat('dd MMM yyyy, HH:mm').format(order.orderDate)}',
            ),
            const SizedBox(height: 16),
            const Text('Delivery Address:'),
            Text(order.deliveryAddress),
            const SizedBox(height: 24),
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...order.items.map((item) => ListTile(
                  title: Text(item.medicine.name),
                  subtitle: Text('${item.quantity} strips'),
                  trailing: Text('₹${item.totalPrice.toStringAsFixed(2)}'),
                )),
            const Divider(),
            ListTile(
              title: const Text('Total Amount'),
              trailing: Text(
                '₹${order.totalAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/home'),
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
