# Book Store Mobile App

A Flutter mobile application for an online book store, featuring user authentication, product browsing, shopping cart functionality, and user profile management.

## Features

- User Authentication
  - Login with email and password
  - Registration with email, password, and name
  - Secure storage of user credentials

- Product Catalog
  - Browse books by category
  - Search functionality
  - Product details view
  - Price and discount display

- Shopping Cart
  - Add/remove items
  - Update quantities
  - Calculate total price
  - Persistent storage

- User Profile
  - View and edit profile information
  - Order history
  - Wishlist
  - Address management

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/bookstore.git
```

2. Navigate to the project directory:
```bash
cd bookstore
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
|-- models/
|   |-- user.dart
|   |-- book.dart
|   |-- cart_item.dart
|-- providers/
|   |-- auth_provider.dart
|   |-- book_provider.dart
|   |-- cart_provider.dart
|-- screens/
|   |-- login_screen.dart
|   |-- register_screen.dart
|   |-- home_screen.dart
|   |-- category_screen.dart
|   |-- cart_screen.dart
|   |-- account_screen.dart
|-- widgets/
|   |-- bottom_nav_bar.dart
|   |-- drawer_menu.dart
|   |-- product_item.dart
|-- utils/
|   |-- constants.dart
|   |-- validators.dart
|-- main.dart
```

## Dependencies

- provider: ^6.1.1
- shared_preferences: ^2.2.2
- flutter_secure_storage: ^9.0.0

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Provider package for state management
- All contributors who help improve this project
#   f i n a l m o b i l e  
 