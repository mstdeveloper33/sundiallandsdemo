// Import necessary packages for dependency injection
import 'package:get_it/get_it.dart';
import '../services/api_service.dart';
import '../services/sqlite_service.dart';

// Create a singleton instance of GetIt for service locator
final locator = GetIt.instance;

// Function to set up the service locator
Future<void> setupLocator() async {
  // Register ApiService as a lazy singleton
  locator.registerLazySingleton<ApiService>(() => ApiService());
  // Register SQLiteService as a lazy singleton
  locator.registerLazySingleton<SQLiteService>(() => SQLiteService());
}