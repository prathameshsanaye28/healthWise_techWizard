

import 'package:healthwise_patient_app/patient_base/models/prescription_models.dart';

class CartItem {
  final Medicine medicine;
  int quantity;
  final int requiredStrips;

  CartItem({
    required this.medicine,
    required this.quantity,
    required this.requiredStrips,
  });

  double get totalPrice => medicine.price * quantity;

  Map<String, dynamic> toJson() => {
    'medicine': medicine.toJson(),
    'quantity': quantity,
    'requiredStrips': requiredStrips,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    medicine: Medicine.fromJson(json['medicine']),
    quantity: json['quantity'],
    requiredStrips: json['requiredStrips'],
  );
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final DateTime orderDate;
  final double totalAmount;
  final String status;
  final String deliveryAddress;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'items': items.map((item) => item.toJson()).toList(),
    'orderDate': orderDate.toIso8601String(),
    'totalAmount': totalAmount,
    'status': status,
    'deliveryAddress': deliveryAddress,
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    userId: json['userId'],
    items: (json['items'] as List)
        .map((item) => CartItem.fromJson(item))
        .toList(),
    orderDate: DateTime.parse(json['orderDate']),
    totalAmount: json['totalAmount'],
    status: json['status'],
    deliveryAddress: json['deliveryAddress'],
  );
}