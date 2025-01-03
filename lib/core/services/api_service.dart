// Import necessary packages for JSON handling and Flutter services
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/health_metrics_model.dart';
import '../models/motivational_message.dart';

// Service class for fetching data from local JSON files
class ApiService {
  // Method to fetch health metrics from a JSON file
  Future<List<HealthMetrics>> fetchHealthMetrics() async {
    try {
      // Load the JSON file from assets
      final String response = await rootBundle
          .loadString('lib/assets/modeljson/wearable_data.json');
      // Decode the JSON response into a list
      final List<dynamic> data = jsonDecode(response);
      // Map the JSON data to HealthMetrics objects and return the list
      return data.map((json) => HealthMetrics.fromJson(json)).toList();
    } catch (e) {
      // Throw an exception if an error occurs
      throw Exception("$e");
    }
  }

  // Method to fetch motivational messages from a JSON file
  Future<List<MotivationalMessage>> fetchMotivationalMessages() async {
    try {
      // Load the JSON file from assets
      final String response = await rootBundle
          .loadString('lib/assets/modeljson/motivational_messages.json');
      // Decode the JSON response into a list
      final List<dynamic> data = jsonDecode(response);
      // Map the JSON data to MotivationalMessage objects and return the list
      return data.map((json) => MotivationalMessage.fromJson(json)).toList();
    } catch (e) {
      // Throw an exception if an error occurs
      throw Exception("$e");
    }
  }
}