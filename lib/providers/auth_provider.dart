import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sirepa_mobile/services/api_service.dart';
import 'package:sirepa_mobile/models/user.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();

  User? _user;
  String? _token;

  User? get user => _user;
  String? get token {
  // Prioritize user token, fall back to stored token
    return _user?.token ?? _token;
  }

  bool get isAuthenticated => token != null;

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      
      // Check if login was successful
      if (response['success'] == true) {
        final data = response['data'];
        
        // Extract token safely
        _token = data['token'] ?? data['access_token'];
        _user = User.fromJson(data['user'] ?? data);

        // Store token securely
        if (_token != null) {
          await _storage.write(key: 'auth_token', value: _token);
        }

        notifyListeners();
        return true;
      } else {
        // Login failed
        print('Login failed: ${response['message']}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> loadStoredToken() async {
    _token = await _storage.read(key: 'auth_token');
    if (_token != null) {
      // Here you might want to validate the token or refresh it
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }

  // Safe token retrieval method
  String? getSafeToken() {
    return _user?.token ?? _token;
  }
}