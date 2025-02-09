// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:healthwise/models/cart_models.dart' as model;
// import 'package:healthwise/models/prescription_models.dart';
// import 'package:healthwise/screens/order_confirmation.dart';
// import 'package:healthwise/services/medicine_reminder.dart';

// class CartScreen extends StatefulWidget {
//   final String userId;
//   final List<PrescribedMedicine> medicines;

//   const CartScreen({
//     Key? key,
//     required this.userId,
//     required this.medicines,
//   }) : super(key: key);

//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   late List<model.CartItem> _cartItems;
//   final _addressController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _initializeCart();
//   }

//   void _initializeCart() {
//     _cartItems = widget.medicines.map((medicine) => model.CartItem(
//       medicine: medicine.medicine,
//       quantity: medicine.medicine.calculateRequiredStrips(),
//       requiredStrips: medicine.medicine.calculateRequiredStrips(),
//     )).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//           appBar: AppBar(
//         title: const Text('Cart'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _initializeCart,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _cartItems.length,
//               itemBuilder: (context, index) => _buildCartItem(_cartItems[index]),
//             ),
//           ),
//           _buildCheckoutSection(),
//         ],
//       ),
//     );
//   }

//   Widget _buildCartItem(model.CartItem item) {
//     return Card(
//       margin: const EdgeInsets.all(8),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         item.medicine.name,
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                       Text('₹${item.medicine.price} per strip'),
//                       Text('Required strips: ${item.requiredStrips}'),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.remove),
//                       onPressed: () => _updateQuantity(item, -1),
//                     ),
//                     Text('${item.quantity}'),
//                     IconButton(
//                       icon: const Icon(Icons.add),
//                       onPressed: () => _updateQuantity(item, 1),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Text('Total: ₹${item.totalPrice.toStringAsFixed(2)}'),
//             if (item.quantity < item.requiredStrips)
//               const Text(
//                 'Warning: Quantity less than prescribed amount',
//                 style: TextStyle(color: Colors.red),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCheckoutSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           TextFormField(
//             controller: _addressController,
//             decoration: const InputDecoration(
//               labelText: 'Delivery Address',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Total Amount:',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   Text(
//                     '₹${_calculateTotal().toStringAsFixed(2)}',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                 ],
//               ),
//               ElevatedButton(
//                 onPressed: _processCheckout,
//                 child: const Text('Proceed to Checkout'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   double _calculateTotal() {
//     return _cartItems.fold(0, (total, item) => total + item.totalPrice);
//   }

//   void _updateQuantity(model.CartItem item, int change) {
//     setState(() {
//       if(1>= item.quantity + change)
//        item.quantity = 1;
//       else item.quantity = item.quantity + change;
//     });
//   }

//   Future<void> _processCheckout() async {
//     if (_addressController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter delivery address')),
//       );
//       return;
//     }

//     try {
//       // Create order
//       final order = model.Order(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         userId: widget.userId,
//         items: _cartItems,
//         orderDate: DateTime.now(),
//         totalAmount: _calculateTotal(),
//         status: 'pending',
//         deliveryAddress: _addressController.text,
//       );

//       // Save order to Firestore
//       await FirebaseFirestore.instance
//           .collection('orders')
//           .doc(order.id)
//           .set(order.toJson());

//       // Schedule reminders for reordering
//       MedicineReminder.scheduleReminders(
//         widget.userId,
//         _cartItems.map((item) => item.medicine).toList(),
//         _cartItems.asMap().map((_, item) => MapEntry(item.medicine.id, item.quantity)),
//       );

//       // Show success message and navigate to order confirmation
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => OrderConfirmationScreen(order: order),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error processing order: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _addressController.dispose();
//     super.dispose();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthwise_patient_app/patient_base/models/cart_models.dart'
    as model;
import 'package:healthwise_patient_app/patient_base/models/prescription_models.dart';
import 'package:healthwise_patient_app/patient_base/views/ecommerce/medicine_reminder.dart';
import 'package:healthwise_patient_app/patient_base/views/ecommerce/order_confirmation.dart';

class CartScreen extends StatefulWidget {
  final String userId;

  const CartScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<model.CartItem> _cartItems;
  final _addressController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  /// Fetch prescribed medicines for the user from Firestore
  Future<void> _fetchMedicines() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot prescriptionSnapshot = await FirebaseFirestore.instance
          .collection('prescriptions')
          .where('patientId', isEqualTo: widget.userId)
          .get();

      List<PrescribedMedicine> prescribedMedicines = [];

      for (var doc in prescriptionSnapshot.docs) {
        Prescription prescription =
            Prescription.fromJson(doc.data() as Map<String, dynamic>);
        prescribedMedicines.addAll(prescription.medicines);
      }

      setState(() {
        _cartItems = prescribedMedicines
            .map((medicine) => model.CartItem(
                  medicine: medicine.medicine,
                  quantity: medicine.medicine.calculateRequiredStrips(),
                  requiredStrips: medicine.medicine.calculateRequiredStrips(),
                ))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching medicines: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchMedicines, // Refresh from Firestore
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loader while fetching data
          : _cartItems.isEmpty
              ? const Center(
                  child: Text("No medicines found in prescriptions."))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) =>
                            _buildCartItem(_cartItems[index]),
                      ),
                    ),
                    _buildCheckoutSection(),
                  ],
                ),
    );
  }

  Widget _buildCartItem(model.CartItem item) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.medicine.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text('₹${item.medicine.price} per strip'),
                      Text('Required strips: ${item.requiredStrips}'),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _updateQuantity(item, -1),
                    ),
                    Text('${item.quantity}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _updateQuantity(item, 1),
                    ),
                  ],
                ),
              ],
            ),
            Text('Total: ₹${item.totalPrice.toStringAsFixed(2)}'),
            if (item.quantity < item.requiredStrips)
              const Text(
                'Warning: Quantity less than prescribed amount',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Delivery Address',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '₹${_calculateTotal().toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _processCheckout,
                child: const Text('Proceed to Checkout'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateTotal() {
    return _cartItems.fold(0, (total, item) => total + item.totalPrice);
  }

  void _updateQuantity(model.CartItem item, int change) {
    setState(() {
      int newQuantity = item.quantity + change;
      item.quantity = newQuantity.clamp(1, item.requiredStrips);
    });
  }

  Future<void> _processCheckout() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter delivery address')),
      );
      return;
    }

    try {
      final order = model.Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.userId,
        items: _cartItems,
        orderDate: DateTime.now(),
        totalAmount: _calculateTotal(),
        status: 'pending',
        deliveryAddress: _addressController.text,
      );

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.id)
          .set(order.toJson());

      MedicineReminder.scheduleReminders(
        widget.userId,
        _cartItems.map((item) => item.medicine).toList(),
        _cartItems
            .asMap()
            .map((_, item) => MapEntry(item.medicine.id, item.quantity)),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirmationScreen(order: order),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing order: $e')),
      );
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}
