import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/book.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  
  List<Order> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final timestamp = DateTime.now();
    final newOrder = Order(
      id: timestamp.toIso8601String(),
      total: total,
      items: cartItems.map((item) => CartItem(
        book: Book(
          id: item.book.id,
          title: item.book.title,
          author: item.book.author,
          description: item.book.description,
          category: item.book.category,
          price: item.book.price,
          imageUrl: item.book.imageUrl,
          rating: item.book.rating,
          reviewCount: item.book.reviewCount,
          stock: item.book.stock,
          isOnSale: item.book.isOnSale,
          salePrice: item.book.salePrice,
        ),
        quantity: item.quantity,
      )).toList(),
      dateTime: timestamp,
    );

    _orders.insert(0, newOrder);
    notifyListeners();
    
    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    final orderData = _orders.map((order) => order.toJson()).toList();
    await prefs.setString('orders', json.encode(orderData));
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final orderData = prefs.getString('orders');
    
    if (orderData != null) {
      final List<dynamic> decodedData = json.decode(orderData);
      _orders = decodedData.map((item) => Order.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> clearOrders() async {
    _orders = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('orders');
    notifyListeners();
  }
} 