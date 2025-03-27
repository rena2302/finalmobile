import 'package:flutter/foundation.dart';
import '../models/book.dart';

class WishlistProvider with ChangeNotifier {
  final List<Book> _items = [];

  List<Book> get items => [..._items];

  bool isInWishlist(String bookId) {
    return _items.any((item) => item.id == bookId);
  }

  void addToWishlist(Book book) {
    if (!isInWishlist(book.id)) {
      _items.add(book);
      notifyListeners();
    }
  }

  void removeFromWishlist(String bookId) {
    _items.removeWhere((item) => item.id == bookId);
    notifyListeners();
  }

  void toggleWishlist(Book book) {
    if (isInWishlist(book.id)) {
      removeFromWishlist(book.id);
    } else {
      addToWishlist(book);
    }
  }
}
