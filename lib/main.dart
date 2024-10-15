import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/booking_options.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const JKHospitalityApp());
}

class JKHospitalityApp extends StatefulWidget {
  const JKHospitalityApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JKHospitalityAppState createState() => _JKHospitalityAppState();
}

class _JKHospitalityAppState extends State<JKHospitalityApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // Use delayed navigation after splash screen
    _checkLoginStatus();
  }

  // Check if the user is logged in using SharedPreferences
  Future<void> _checkLoginStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      //print("Is user logged in? $isLoggedIn");

      setState(() {
        _isLoggedIn = isLoggedIn;
      });
    } catch (e) {
      print("Error while checking login status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JK Hospitality',
      theme: AppTheme.lightTheme,
      home: SplashScreen(
        isLoggedIn: _isLoggedIn,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  const SplashScreen({required this.isLoggedIn, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    //print("Navigating to next screen");

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 5),
        pageBuilder: (context, animation, secondaryAnimation) {
          return widget.isLoggedIn
              ? const BookingOptions()
              : const LoginScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset(0.0, 0.0);
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var fadeTween =
              Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation.drive(fadeTween),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 12, 78, 176), // Dark blue background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/national_emb.png', // Replace with your background image path
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              'Union Territory of Jammu and Kashmir',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'images/logo.png', // Replace with your logo path
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text(
                  'आतिथ्य तथा प्रोटोकॉल विभाग',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
                Text(
                  'Department of Hospitality and Protocol',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
                Text(
                  'مہمان نوازی اور پروٹوکول محکمہ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
