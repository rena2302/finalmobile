import 'book.dart';

class CartItem {
  final Book book;
  int quantity;

  CartItem({
    required this.book,
    this.quantity = 1,
  });

  double get totalPrice {
    return book.isOnSale && book.salePrice != null
        ? book.salePrice! * quantity
        : book.price * quantity;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      book: Book(
        id: json['bookId'],
        title: json['title'],
        price: json['price'].toDouble(),
        imageUrl: json['imageUrl'],
        description: '',
        author: '',
        category: '',
        rating: 0.0,
        reviewCount: 0,
        stock: 0,
      ),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': book.id,
      'title': book.title,
      'price': book.price,
      'imageUrl': book.imageUrl,
      'quantity': quantity,
    };
  }
}
