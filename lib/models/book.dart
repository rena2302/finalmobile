class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String category;
  final double price;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isOnSale;
  final double? salePrice;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stock = 0,
    this.isOnSale = false,
    this.salePrice,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      category: json['category'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      stock: json['stock'] ?? 0,
      isOnSale: json['isOnSale'] as bool? ?? false,
      salePrice:
          json['salePrice'] != null
              ? (json['salePrice'] as num).toDouble()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'stock': stock,
      'isOnSale': isOnSale,
      'salePrice': salePrice,
    };
  }
}
