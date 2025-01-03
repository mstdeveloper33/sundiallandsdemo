// Import necessary packages for routing
import 'package:go_router/go_router.dart';
import '../../presentation/screens/dashboard/view/dashboard_view.dart';
import '../../presentation/screens/journaling/view/journal_view.dart';
import '../../presentation/screens/onboarding/view/onboarding_view.dart';
import '../../presentation/screens/splash/splahs_screen.dart';

// Class to manage application routing
class AppRouter {
  // Static instance of GoRouter for defining routes
  static final router = GoRouter(
    routes: [
      // Route for the splash screen
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      // Route for the onboarding screen
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      // Route for the journaling screen
      GoRoute(
        path: '/journal',
        builder: (context, state) => const JournalingView(),
      ),
      // Route for the dashboard screen
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardView(),
      ),
    ],
  );
}