import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sirepa_mobile/providers/auth_provider.dart';
import 'package:sirepa_mobile/providers/dashboard_provider.dart';
import 'package:sirepa_mobile/screens/login_screen.dart';
import 'package:sirepa_mobile/screens/dashboard_screen.dart';
import 'package:sirepa_mobile/screens/splash_screen.dart'; // Recommended to add
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        title: 'SIREPA Mobile',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // Customize app-wide theme
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.blue[500],
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English
          const Locale('id', ''), // Indonesian
          // Add other supported locales here if needed
        ],
        // Use initial route and route generation
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(), // Add a splash screen
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
        // Add route generator for more complex routing
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(
                builder: (context) => const LoginScreen(),
                settings: settings,
              );
            case '/dashboard':
              return MaterialPageRoute(
                builder: (context) => const DashboardScreen(),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const SplashScreen(),
                settings: settings,
              );
          }
        },
        // Add error handling for unknown routes
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(
                child: Text('Page not found'),
              ),
            ),
          );
        },
      ),
    );
  }
}
