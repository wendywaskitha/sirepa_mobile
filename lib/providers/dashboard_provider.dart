import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:sirepa_mobile/models/dashboard_stats.dart';
import 'package:sirepa_mobile/services/api_service.dart';

class DashboardProvider with ChangeNotifier {
  DashboardStats? _stats;
  bool _isLoading = false;
  String? _error;

  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDashboardStats(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dio = Dio();
      dio.options.baseUrl = 'http://10.0.2.2:8000/api';
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get('/admin/dashboard/stats');
      
      if (response.statusCode == 200) {
        _stats = DashboardStats.fromJson(response.data['data']);
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load dashboard stats');
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  String _handleError(dynamic error) {
    // Handle errors as necessary
    return error.toString(); // Simplified for this example
  }
}