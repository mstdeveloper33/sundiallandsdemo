
// Import necessary packages for Flutter and routing
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// SplashScreen widget to display a splash screen at app startup
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Wait for 3 seconds and then navigate to the onboarding page
    Future.delayed(const Duration(seconds: 3), () {
      GoRouter.of(context)
          .go('/onboarding'); // Navigate to the onboarding route
    });

    return Scaffold(
      body: Container(
        color: Colors.white, // Background color of the splash screen
        child: Center(
          child: Container(
            child: Image.asset(
              "lib/assets/splash/splash.png", // Path to the splash image
              fit: BoxFit.cover, // Cover the entire area with the image
            ),
          ),
        ),
      ),
    );
  }
}
