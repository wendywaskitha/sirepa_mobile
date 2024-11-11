import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:sirepa_mobile/models/user.dart';
import 'package:sirepa_mobile/providers/auth_provider.dart';
import 'package:sirepa_mobile/screens/login_screen.dart';
import 'package:sirepa_mobile/services/api_service.dart';
import 'package:badges/badges.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sirepa_mobile/widgets/welcome_header.dart';
import 'package:sirepa_mobile/widgets/quick_stats.dart';
import 'package:sirepa_mobile/widgets/quick_actions.dart';
import 'package:sirepa_mobile/models/retribusi_pembayaran.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<RetribusiPembayaran> retribusiList = [];
  bool isLoading = true;
  int paidCount = 0;
  int unpaidCount = 0;

  @override
  void initState() {
    super.initState();
    _loadRetribusiPembayarans();
  }

  Future<void> _loadRetribusiPembayarans() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String token = authProvider.user?.token ?? '';

    try {
      final apiService = ApiService();
      final data = await apiService.fetchRetribusiPembayarans(token);
      setState(() {
        retribusiList = data;
        isLoading = false;
      });

      // Calculate paid and unpaid counts
      final paymentStats = await getPaymentStats(retribusiList);
      setState(() {
        paidCount = paymentStats['paid'] ?? 0;
        unpaidCount = paymentStats['unpaid'] ?? 0;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e is DioException) {
        // Handle Dio specific errors
        if (e.response != null) {
          // Check for specific status codes
          if (e.response?.statusCode == 500) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Server error: ${e.response?.data}'),
                duration: Duration(seconds: 3),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Error fetching payment data: ${e.response?.statusCode} - ${e.response?.data}'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else {
          // Handle other Dio errors
          print('DioException: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error fetching payment data: ${e.message}'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Handle unexpected errors
        print('Unexpected error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error fetching payment data: $e'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<Map<String, int>> getPaymentStats(
      List<RetribusiPembayaran> payments) async {
    final String today = DateTime.now()
        .toIso8601String()
        .split('T')[0]; // Get today's date in YYYY-MM-DD format

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

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true; // Show loading indicator while refreshing
    });
    await _loadRetribusiPembayarans(); // Refresh data
  }

  // String getCurrentDate() {
  //   final now = DateTime.now();
  //   final formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
  //   return formatter.format(now);
  // }

  String getCurrentDate() {
    final DateTime now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  void _onPaymentTap() {
    // Navigate to payment screen or perform payment action
    print('Payment tapped');
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen()));
  }

  void _onReportTap() {
    // Navigate to report screen or perform report action
    print('Report tapped');
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  WelcomeHeader(),
                  const SizedBox(height: 16),
                  // Display the current date
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      getCurrentDate(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Display paid and unpaid counts
                  if (!isLoading)
                    Column(
                      children: [
                        Text('Pedagang Sudah Bayar: $paidCount'),
                        Text('Pedagang Belum Bayar: $unpaidCount'),
                      ],
                    ),
                  // Loading Indicator
                  if (isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (retribusiList.isEmpty)
                    Center(child: Text('No data available'))
                  else
                    // Display the list of retribusi payments
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: retribusiList.length,
                      itemBuilder: (context, index) {
                        final retribusi = retribusiList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title: Text(
                                'ID: ${retribusi.id} - ${retribusi.pedagang.name}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Total: Rp ${retribusi.totalBiaya.toStringAsFixed(2)}'),
                                Text('Status: ${retribusi.status}'),
                                Text(
                                    'Tanggal Bayar: ${DateFormat('dd MMMM yyyy').format(retribusi.tanggalBayar)}'), // Format date
                                Text('Pasar: ${retribusi.pasar.name}'),
                              ],
                            ),
                            onTap: () {
                              // Handle tap, e.g., navigate to details
                            },
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                  QuickActions(
                    onPaymentTap: _onPaymentTap, // Use the QuickActions widget
                    onReportTap: _onReportTap,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern App Bar with Logout
  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.grey.shade800),
        onPressed: () {
          // Add menu functionality
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: Colors.grey.shade800),
          onPressed: () {
            // Add notifications functionality
          },
        ),
        IconButton(
          icon: Icon(Icons.logout, color: Colors.red.shade400),
          onPressed: () => _showLogoutConfirmationDialog(context),
        ),
      ],
    );
  }

  // Logout Confirmation Dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
