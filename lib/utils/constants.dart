class AppConstants {
  static const String appName = 'Book Store';

  // API endpoints
  static const String baseUrl = 'https://api.example.com';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String booksEndpoint = '/books';
  static const String categoriesEndpoint = '/categories';

  // Storage keys
  static const String userKey = 'user';
  static const String cartKey = 'cart';

  // Validation
  static const int minPasswordLength = 6;
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultIconSize = 24.0;

  // Sample data
  static const List<Map<String, dynamic>> sampleBooks = [
    {
      'id': '1',
      'title': 'The Great Gatsby',
      'author': 'F. Scott Fitzgerald',
      'description': 'A story of decadence and excess...',
      'price': 15.99,
      'imageUrl': 'https://example.com/gatsby.jpg',
      'category': 'Fiction',
      'rating': 4.5,
      'reviewCount': 120,
      'stock': 50,
    },
    {
      'id': '2',
      'title': '1984',
      'author': 'George Orwell',
      'description': 'A dystopian social science fiction novel...',
      'price': 12.99,
      'imageUrl': 'https://example.com/1984.jpg',
      'category': 'Fiction',
      'rating': 4.8,
      'reviewCount': 200,
      'isOnSale': true,
      'salePrice': 9.99,
      'stock': 30,
    },
    {
      'id': '3',
      'title': 'The Hobbit',
      'author': 'J.R.R. Tolkien',
      'description':
          'Bilbo Baggins is a hobbit who enjoys a comfortable, unambitious life...',
      'price': 14.99,
      'imageUrl': 'https://example.com/hobbit.jpg',
      'category': 'Fantasy',
      'rating': 4.7,
      'reviewCount': 150,
      'stock': 40,
    },
  ];

  static const List<String> categories = [
    'Fiction',
    'Fantasy',
    'Science Fiction',
    'Mystery',
    'Romance',
    'Biography',
    'History',
    'Poetry',
  ];
}
