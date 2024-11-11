import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sirepa_mobile/models/pedagang.dart';
import 'package:sirepa_mobile/models/target_retribusi.dart';
import 'package:sirepa_mobile/models/retribusi_pembayaran.dart';

// Add this class to define your base URL
class Constants {
  static const String baseUrl =
      'http://10.0.2.2:8000/api'; // Update with your actual base URL
}

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = Constants.baseUrl;

    // Add logging interceptor for debugging
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        print('REQUEST DATA: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print(
            'ERROR[${e.response?.statusCode}] => MESSAGE: ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }

  // Method to fetch retribusi pembayaran
  Future<List<RetribusiPembayaran>> fetchRetribusiPembayarans(
      String token) async {
    try {
      final response = await _dio.get('/admin/retribusi-pembayarans/',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          }));

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => RetribusiPembayaran.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load retribusi pembayaran: ${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Could not fetch retribusi pembayaran: $e');
    }
  }

  // Add a method to fetch dashboard stats
  // Future<Map<String, dynamic>> getDashboardStats(String token) async {
  //   try {
  //     final response = await _dio.get(
  //       '/dashboard/stats',
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json',
  //         },
  //       ),
  //     );

  //     return response.data;
  //   } catch (e) {
  //     print('Error fetching dashboard stats: $e');
  //     rethrow;
  //   }
  // }

  // Existing login method
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // // Fetch Pedagangs method
  // Future<List<Pedagang>> fetchPedagangs(String token) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse(
  //           '${Constants.baseUrl}/admin/pedagangs'), // Corrected URI parsing
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       // Parse the JSON response
  //       final List<dynamic> pedagangJson =
  //           json.decode(response.body)['data'] ?? [];
  //       return pedagangJson.map((json) => Pedagang.fromJson(json)).toList();
  //     } else {
  //       // Handle error scenarios
  //       throw Exception('Failed to load pedagangs: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error fetching pedagangs: $e');
  //     throw Exception('Could not fetch pedagangs: $e');
  //   }
  // }

  // Method to fetch target retribusi
  Future<List<TargetRetribusi>> fetchTargetRetribusis(String token) async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/admin/target-retribusis'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      return data.map((json) => TargetRetribusi.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load target retribusi');
    }
  }

  // New token validation method
  Future<Map<String, dynamic>> validateToken(String? token) async {
    try {
      final response = await _dio.get('/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return {'valid': true, 'user': response.data};
    } catch (e) {
      return {'valid': false};
    }
  }

  // // New method to fetch retribusi pembayaran
  // Future<List<Map<String, dynamic>>> fetchRetribusiPembayarans(
  //     String token) async {
  //   try {
  //     final response = await _dio.get('/admin/retribusi-pembayarans',
  //         options: Options(headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json',
  //         }));

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = response.data['data'];
  //       return data.map((json) => json as Map<String, dynamic>).toList();
  //     } else {
  //       throw Exception('Failed to load retribusi pembayaran');
  //     }
  //   } catch (e) {
  //     print('Error fetching retribusi pembayaran: $e');
  //     throw Exception('Could not fetch retribusi pembayaran: $e');
  //   }
  // }

  Future<Map<String, int>> getPaymentStats(
      List<RetribusiPembayaran> payments) async {
    final String today = DateTime.now().toIso8601String().split('T')[0];

    int paidCount = 0;
    int unpaidCount = 0;

    final Set<int> paidPedagangIds = {};
    final Set<int> allPedagangIds = {};

    for (var payment in payments) {
      allPedagangIds.add(payment.pedagangId);
      if (payment.tanggalBayar.toIso8601String().split('T')[0] == today) {
        paidPedagangIds.add(payment.pedagangId);
      }
    }

    paidCount = paidPedagangIds.length;
    unpaidCount = allPedagangIds.length - paidCount;

    return {
      'paid': paidCount,
      'unpaid': unpaidCount,
    };
  }

  Future<List<Map<String, dynamic>>> fetchRetribusiRealizationReports(
      String token) async {
    try {
      final response = await _dio.get('/admin/retribusi-realization-reports/',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          }));

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        print('Retribusi realization reports fetched: $data'); // Debugging line
        return data.map((json) => json as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load retribusi realization reports');
      }
    } catch (e) {
      print('Error fetching retribusi realization reports: $e');
      throw Exception('Could not fetch retribusi realization reports: $e');
    }
  }

  // New logout method
  Future<void> logout(String? token) async {
    try {
      await _dio.post('/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
    } catch (e) {
      // Handle logout errors
      print('Logout error: $e');
    }
  }
}
