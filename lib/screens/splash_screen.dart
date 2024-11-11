import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sirepa_mobile/providers/auth_provider.dart';
import 'package:sirepa_mobile/screens/login_screen.dart';
import 'package:sirepa_mobile/screens/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Delay to simulate splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Get auth provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if token exists and is valid
    if (authProvider.token != null) {
      // Validate token
      try {
        // You might want to add a method in ApiService to validate token
        // await authProvider.validateToken();

        // If token is valid, navigate to dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } catch (e) {
        // Token invalid, navigate to login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      // No token, go to login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app logo or name
            Image.asset(
              'assets/logo.png', // Add your app logo
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'SIREPA Mobile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}