
// Import necessary packages for Flutter and dependency injection
import 'package:flutter/material.dart';
import '../../../../core/dependencies/locator.dart';
import '../../../../core/models/motivational_message.dart';
import '../../../../core/services/api_service.dart';

// OnboardingViewModel class to manage onboarding data and state
class OnboardingViewModel extends ChangeNotifier {
  final _apiService =
      locator<ApiService>(); // Dependency injection for API service

  List<MotivationalMessage>?
      motivationalMessages; // List to hold motivational messages

  // Method to load motivational messages from the API
  Future<void> loadMotivationalMessage() async {
    motivationalMessages = await _apiService
        .fetchMotivationalMessages(); // Fetch messages from the API
    notifyListeners(); // Notify listeners to update the UI
  }
}
