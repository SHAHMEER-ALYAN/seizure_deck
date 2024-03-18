import 'package:flutter/material.dart';
import 'package:seizure_deck/Views/login.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Add a delay and navigate to the main screen
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    });

    return Scaffold(
      // Customize your splash screen UI here
      body: Center(
        child: Image.asset('assets/slogo.png'),
      ),
    );
  }
}
