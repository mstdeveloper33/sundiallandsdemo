import 'package:flutter/material.dart';
import '../../../../core/dependencies/locator.dart';
import '../../../../core/models/health_metrics_model.dart';
import '../../../../core/models/journal_entry_model.dart';
import '../../../../core/models/motivational_message.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/sqlite_service.dart';

// ViewModel class for managing journaling logic and state
class JournalingViewModel extends ChangeNotifier {
  // Text editing controller for journal text input
  final TextEditingController textController = TextEditingController();
  // API service for fetching data
  final ApiService _apiService = locator<ApiService>();
  // SQLite service for local database operations
  final SQLiteService _sqliteService;
  // Lists to hold health metrics and motivational messages
  List<HealthMetrics> healthMetrics = [];
  List<MotivationalMessage> motivationalMessages = [];
  // Constructor initializes SQLite service and loads entries and metrics
  JournalingViewModel(this._sqliteService) {
    loadEntries();
    loadHealthMetrics(); // Load data when the application starts
  }
  // Variables to hold journal text and selected mood
  String journalText = '';
  String selectedMood = "😊"; // Default mood
  List<JournalEntry> journalEntries = [];
  JournalEntry? editingEntry;

  Future<void> fetchHealthMetrics() async {
    try {
      final apiService = locator<ApiService>();
      healthMetrics = await apiService.fetchHealthMetrics();
      notifyListeners();
    } catch (e) {
      healthMetrics = [];
      notifyListeners();
    }
  }

  Future<void> fetchMotivationalMessages() async {
    try {
      final apiService = locator<ApiService>();
      motivationalMessages = await apiService.fetchMotivationalMessages();
      notifyListeners();
    } catch (e) {
      motivationalMessages = [];
      notifyListeners();
    }
  }

  HealthMetrics? getCurrentDayHealthMetrics() {
    final now = DateTime.now();
    return healthMetrics.firstWhere(
      (metric) => _isSameDay(metric.lastUpdated, now),
      orElse: () => HealthMetrics(
        steps: 0,
        heartRate: 0,
        lastUpdated: now,
      ),
    );
  }

  MotivationalMessage? getCurrentDayMotivationalMessage() {
    final now = DateTime.now();
    return motivationalMessages.firstWhere(
      (message) => _isSameDay(message.date, now),
      orElse: () => MotivationalMessage(
        message: "Make today count!",
        date: now,
      ),
    );
  }

  // Method to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Method to check if two dates are the same day
  void updateJournalText(String text) {
    journalText = text;
    notifyListeners();
  }

  // Method to update selected mood and notify listeners
  void updateMood(String mood) {
    selectedMood = mood;
    notifyListeners();
  }

// Method to cancel editing mode
  void cancelEditing() {
    editingEntry = null;
    journalText = '';
    selectedMood = "😊";
    textController.clear();
    notifyListeners();
  }

  // Method to save journal entry to the database
  Future<void> saveEntry() async {
    final entryDate = DateTime.now();
    final entry = JournalEntry(
      id: editingEntry?.id,
      text: journalText,
      mood: selectedMood,
      date: entryDate.toIso8601String(),
    );
    await _sqliteService.saveJournalEntry(entry);
    journalText = '';
    selectedMood = "😊";
    editingEntry = null;
    await loadEntries();
  }

  // Method to load journal entries from the database
  Future<void> loadEntries() async {
    journalEntries = await _sqliteService.getJournalEntries();
    journalEntries = journalEntries.reversed.toList(); // Listeyi ters çevir
    notifyListeners();
  }

  // Method to delete a journal entry by ID
  Future<void> deleteEntry(int id) async {
    await _sqliteService.deleteJournalEntry(id);
    await loadEntries();
  }

  // Method to edit a specific journal entry
  void editEntry(JournalEntry entry) {
    journalText = entry.text;
    selectedMood = entry.mood;
    editingEntry = entry;
    textController.text = entry.text;
    notifyListeners();
  }

// Method to get mood counts for the current week
  Map<String, Map<int, int>> getMoodCountsForCurrentWeek() {
    Map<String, Map<int, int>> moodCounts = {
      "😊": {},
      "😞": {},
      "😠": {},
    };

    final now = DateTime.now();
    final endDate = now;
    final startDate = now.subtract(const Duration(days: 6)); // Last 7 days

    for (var entry in journalEntries) {
      DateTime entryDate = DateTime.parse(entry.date);
      // Normalize date to the start of the day
      entryDate = DateTime(entryDate.year, entryDate.month, entryDate.day);

      if (entryDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          entryDate.isBefore(endDate.add(const Duration(days: 1)))) {
        // Calculate the day's index (0-6)
        int dayIndex = entryDate.difference(startDate).inDays + 1;
        moodCounts[entry.mood]?[dayIndex] =
            (moodCounts[entry.mood]?[dayIndex] ?? 0) + 1;
      }
    }

    // Assign 0 value for missing days
    for (int i = 1; i <= 7; i++) {
      moodCounts.forEach((mood, counts) {
        counts.putIfAbsent(i, () => 0);
      });
    }

    return moodCounts;
  }

  // Method to calculate total steps from health metrics
  int calculateTotalSteps() {
    if (healthMetrics.isEmpty) return 0;

    // Get today's date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Sum steps up to today
    return healthMetrics.where((metric) {
      final metricDate = DateTime(metric.lastUpdated.year,
          metric.lastUpdated.month, metric.lastUpdated.day);
      return metricDate.isBefore(today) || metricDate.isAtSameMomentAs(today);
    }).fold(0, (sum, metric) => sum + metric.steps);
  }

  // Method to load health metrics from the API
  Future<void> loadHealthMetrics() async {
    try {
      healthMetrics = await _apiService.fetchHealthMetrics();
      notifyListeners();
    } catch (e) {
      print("$e");
    }
  }
}