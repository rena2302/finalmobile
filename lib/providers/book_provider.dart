import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';

  List<Book> get books => _books;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;

  List<Book> get filteredBooks {
    if (_searchQuery.isEmpty) return _books;

    return _books.where((book) {
      final query = _searchQuery.toLowerCase();
      return book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query) ||
          book.category.toLowerCase().contains(query);
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadBooks() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/books.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      _books = (jsonData['books'] as List)
          .map((bookJson) => Book.fromJson(bookJson))
          .toList();

      _categories = List<String>.from(jsonData['categories']);
    } catch (e) {
      _error = 'Failed to load books: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Book> getBooksByCategory(String category) {
    return _books.where((book) => book.category == category).toList();
  }

  List<String> getCategories() {
    return _books.map((book) => book.category).toSet().toList();
  }

  Book? getBookById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Book> searchBooks(String query) {
    if (query.isEmpty) return _books;

    return _books
        .where((book) =>
            book.title.toLowerCase().contains(query.toLowerCase()) ||
            book.author.toLowerCase().contains(query.toLowerCase()) ||
            book.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
