// Import necessary packages for Flutter, state management, and dependency injection
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/dependencies/locator.dart';
import 'core/router/app_router.dart';
import 'core/services/sqlite_service.dart';
import 'presentation/screens/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'presentation/screens/journaling/viewmodel/journal_viewmodel.dart';
import 'presentation/screens/onboarding/viewmodel/onboarding_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  // Set preferred device orientations to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize SQLite service for local database management
  final sqliteService = SQLiteService();
  await sqliteService.init();

  // Set up dependency injection
  setupLocator();

  runApp(
    MultiProvider(
      providers: [
        // Provide OnboardingViewModel for onboarding screens
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        // Provide JournalingViewModel for journaling functionality
        ChangeNotifierProvider(
            create: (_) => JournalingViewModel(sqliteService)),
        // Provide DashboardViewModel for dashboard functionality
        ChangeNotifierProvider(
            create: (context) => DashboardViewModel(
                Provider.of<JournalingViewModel>(context, listen: false))),
      ],
      child: const MyApp(), // Main application widget
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false, // Hide debug banner
      routerConfig: AppRouter.router, // Set up routing configuration
    );
  }
}