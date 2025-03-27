import 'package:flutter/foundation.dart';
import 'cart_item.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> items;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.total,
    required this.items,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total': total,
      'items': items.map((item) => {
        'bookId': item.book.id,
        'title': item.book.title,
        'quantity': item.quantity,
        'price': item.book.price,
        'imageUrl': item.book.imageUrl,
      }).toList(),
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      total: json['total'],
      items: (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
} 