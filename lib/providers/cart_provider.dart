import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  Set<String> _selectedItems = {};
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  Set<String> get selectedItems => _selectedItems;
  
  double get totalAmount => _items
      .where((item) => _selectedItems.contains(item.book.id))
      .fold(0, (sum, item) => sum + item.totalPrice);

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('cart');
      final selectedJson = prefs.getString('selected_items');

      if (cartJson != null) {
        final List<dynamic> decoded = jsonDecode(cartJson);
        _items = decoded.map((item) => CartItem.fromJson(item)).toList();
      }

      if (selectedJson != null) {
        final List<dynamic> decoded = jsonDecode(selectedJson);
        _selectedItems = Set<String>.from(decoded);
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = jsonEncode(_items.map((item) => item.toJson()).toList());
      final selectedJson = jsonEncode(_selectedItems.toList());
      await prefs.setString('cart', cartJson);
      await prefs.setString('selected_items', selectedJson);
    } catch (e) {
      rethrow;
    }
  }

  void toggleItemSelection(String bookId) {
    if (_selectedItems.contains(bookId)) {
      _selectedItems.remove(bookId);
    } else {
      _selectedItems.add(bookId);
    }
    notifyListeners();
  }

  bool isSelected(String bookId) {
    return _selectedItems.contains(bookId);
  }

  Future<void> addToCart(Book book) async {
    try {
      final existingItemIndex =
          _items.indexWhere((item) => item.book.id == book.id);

      if (existingItemIndex >= 0) {
        _items[existingItemIndex].quantity++;
      } else {
        _items.add(CartItem(book: book));
      }

      await _saveCart();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromCart(String bookId) async {
    try {
      _items.removeWhere((item) => item.book.id == bookId);
      _selectedItems.remove(bookId);
      await _saveCart();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateQuantity(String bookId, int quantity) async {
    try {
      final index = _items.indexWhere((item) => item.book.id == bookId);
      if (index >= 0) {
        if (quantity <= 0) {
          _items.removeAt(index);
          _selectedItems.remove(bookId);
        } else {
          _items[index].quantity = quantity;
        }
        await _saveCart();
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      _items.clear();
      _selectedItems.clear();
      await _saveCart();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  bool isInCart(String bookId) {
    return _items.any((item) => item.book.id == bookId);
  }

  int getQuantity(String bookId) {
    final item = _items.firstWhere(
      (item) => item.book.id == bookId,
      orElse: () => CartItem(
          book: Book(
        id: '',
        title: '',
        author: '',
        description: '',
        price: 0,
        imageUrl: '',
        category: '',
        rating: 0,
        reviewCount: 0,
        stock: 0,
      )),
    );
    return item.quantity;
  }
}
