import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _currentUser;
  Map<String, dynamic>? _currentUserData;
  late String _userFilePath;

  User? get currentUser => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserEmail => _currentUser;
  Map<String, dynamic>? get currentUserData => _currentUserData;

  AuthProvider() {
    initAuth();
  }

  Future<void> initAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _initUserFile();
      await _checkAuthStatus();
    } catch (e) {
      print('Debug - Error in initAuth: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _initUserFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _userFilePath = '${directory.path}/users.json';
      final file = File(_userFilePath);
      
      if (!await file.exists()) {
        print('Debug - Creating new users file');
        await file.writeAsString(json.encode({'users': {}}));
      } else {
        print('Debug - Users file exists, reading content');
        final content = await file.readAsString();
        print('Debug - Current file content: $content');
      }
    } catch (e) {
      print('Debug - Error in _initUserFile: $e');
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('current_user_email');
      
      if (savedEmail != null) {
        final data = await _readUsersFile();
        final users = data['users'] as Map<String, dynamic>;
        
        if (users.containsKey(savedEmail)) {
          _currentUser = savedEmail;
          _currentUserData = Map<String, dynamic>.from(users[savedEmail]);
          _isAuthenticated = true;
          
          _user = User(
            id: '${users[savedEmail]['id'] ?? '1'}',
            name: '${users[savedEmail]['name'] ?? 'User'}',
            email: savedEmail,
            phone: '${users[savedEmail]['phone'] ?? ''}',
            address: '${users[savedEmail]['address'] ?? ''}',
            avatarUrl: users[savedEmail]['avatarUrl']?.toString(),
          );
          
          print('Debug - User restored from saved session');
        }
      }
    } catch (e) {
      print('Debug - Error in _checkAuthStatus: $e');
    }
  }

  Future<Map<String, dynamic>> _readUsersFile() async {
    try {
      final file = File(_userFilePath);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final Map<String, dynamic> data = json.decode(contents);
        if (data['users'] is! Map<String, dynamic>) {
          data['users'] = <String, dynamic>{};
        }
        return data;
      }
      return {'users': <String, dynamic>{}};
    } catch (e) {
      return {'users': <String, dynamic>{}};
    }
  }

  Future<void> _writeUsersFile(Map<String, dynamic> data) async {
    final file = File(_userFilePath);
    await file.writeAsString(json.encode(data));
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _readUsersFile();
      final users = data['users'] as Map<String, dynamic>;
      
      if (!users.containsKey(email)) {
        throw 'Email not registered';
      }

      final userInfo = users[email] as Map<String, dynamic>;
      if (userInfo['password'] != password) {
        throw 'Invalid password';
      }

      _currentUser = email;
      _currentUserData = Map<String, dynamic>.from(userInfo);
      _isAuthenticated = true;

      _user = User(
        id: '${userInfo['id'] ?? '1'}',
        name: '${userInfo['name'] ?? 'User'}',
        email: email,
        phone: '${userInfo['phone'] ?? ''}',
        address: '${userInfo['address'] ?? ''}',
        avatarUrl: userInfo['avatarUrl']?.toString(),
      );

      // Lưu email người dùng hiện tại
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user_email', email);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _readUsersFile();
      final users = data['users'] as Map<String, dynamic>;

      // Kiểm tra email đã tồn tại chưa
      if (users.containsKey(email)) {
        throw 'Email already registered';
      }

      // Tạo user ID mới
      final userId = DateTime.now().millisecondsSinceEpoch.toString();

      // Tạo thông tin user mới
      final newUser = {
        'id': userId,
        'name': 'User',
        'email': email,
        'password': password,
        'phone': '',
        'address': '',
        'avatarUrl': null,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Lưu thông tin user mới
      users[email] = newUser;

      // Lưu lại vào file
      data['users'] = users;
      await _writeUsersFile(data);

      // Debug: In ra nội dung file
      final fileContent = await _readUsersFile();
      print('Debug - File contents after registration:');
      print(json.encode(fileContent));

      // Tự động đăng nhập sau khi đăng ký
      _currentUser = email;
      _currentUserData = newUser;
      _isAuthenticated = true;

      _user = User(
        id: userId,
        name: 'User',
        email: email,
        phone: '',
        address: '',
        avatarUrl: null,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = null;
      _isAuthenticated = false;
      _currentUser = null;
      _currentUserData = null;

      // Xóa email người dùng đã lưu
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user_email');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    String? name,
    String? phone,
    String? address,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) return;

    try {
      final data = await _readUsersFile();
      final users = data['users'] as Map<String, dynamic>;

      if (users.containsKey(_currentUser)) {
        if (name != null) users[_currentUser!]['name'] = name;
        if (phone != null) users[_currentUser!]['phone'] = phone;
        if (address != null) users[_currentUser!]['address'] = address;
        if (avatarUrl != null) users[_currentUser!]['avatarUrl'] = avatarUrl;

        await _writeUsersFile(data);

        _currentUserData = users[_currentUser];
        _user = _user?.copyWith(
          name: name ?? _user?.name,
          phone: phone ?? _user?.phone,
          address: address ?? _user?.address,
          avatarUrl: avatarUrl ?? _user?.avatarUrl,
        );

        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> exportToAssets() async {
    try {
      final data = await _readUsersFile();
      final String jsonString = json.encode(data);
      
      // Lưu vào file tạm thời
      final directory = await getApplicationDocumentsDirectory();
      final tempFile = File('${directory.path}/temp_users.json');
      await tempFile.writeAsString(jsonString);
      
      print('Data exported successfully!');
      print('File location: ${tempFile.path}');
      print('Please copy the contents of this file to assets/data/users.json');
    } catch (e) {
      print('Error exporting to assets: $e');
      rethrow;
    }
  }
}
