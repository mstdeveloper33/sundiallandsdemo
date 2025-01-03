// Import necessary packages for Flutter
import 'package:flutter/material.dart';
import '../../../journaling/viewmodel/journal_viewmodel.dart';

// HighlightCard widget to display mood highlights based on journal entries
class HighlightCard extends StatelessWidget {
  final JournalingViewModel viewModel; // ViewModel for managing journal data

  const HighlightCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    // Check if there are no journal entries
    if (viewModel.journalEntries.isEmpty) {
      return const Card(
        color: Colors.grey, // Grey card for empty state
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("It's pretty quiet around here.",
              style: TextStyle(color: Colors.white)), // Message for empty state
        ),
      );
    }

    // Get mood counts for the current week
    final moodCounts = viewModel.getMoodCountsForCurrentWeek();
    final totalHappy =
        moodCounts["😊"]?.values.fold<int>(0, (sum, count) => sum + count) ??
            0; // Total happy count
    final totalSad =
        moodCounts["😞"]?.values.fold<int>(0, (sum, count) => sum + count) ??
            0; // Total sad count
    final totalAngry =
        moodCounts["😠"]?.values.fold<int>(0, (sum, count) => sum + count) ??
            0; // Total angry count

    // Determine the maximum count among the moods
    final maxCount =
        [totalHappy, totalSad, totalAngry].reduce((a, b) => a > b ? a : b);
    // Get the corresponding message, color, and emojis based on mood counts
    final (message, color, emojis) =
        _getMoodMessageAndColor(totalHappy, totalSad, totalAngry, maxCount);

    return Card(
      color: color, // Set card color based on mood
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(emojis,
                style: const TextStyle(fontSize: 24)), // Display emojis
            const SizedBox(height: 10),
            Text(message,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center), // Display mood message
          ],
        ),
      ),
    );
  }

  // Private method to determine mood message and color based on counts
  (String, Color, String) _getMoodMessageAndColor(
      int totalHappy, int totalSad, int totalAngry, int maxCount) {
    if (totalHappy == totalSad && totalSad == totalAngry) {
      return (
        "It's time to shift the balance in a positive direction.",
        Colors.blue, // Color for neutral mood
        "😊 😞 😠" // Emojis representing all moods
      );
    } else if (totalHappy == totalSad && totalHappy == maxCount) {
      return (
        "It's a bad feeling to be caught between being happy and not being happy.",
        Colors.teal, // Color for mixed happy and sad
        "😞 😊 " // Emojis for mixed moods
      );
    } else if (totalHappy == totalAngry && totalHappy == maxCount) {
      return (
        "Laughter suits you so well, when you're angry it takes away from your beauty.",
        Colors.orange, // Color for happy and angry
        "😊 😠" // Emojis for happy and angry
      );
    } else if (totalSad == totalAngry && totalSad == maxCount) {
      return (
        "It's time to shift the balance in a positive direction.",
        Colors.deepPurple, // Color for mixed sad and angry
        "😞 😠" // Emojis for sad and angry
      );
    } else if (totalHappy == maxCount) {
      return (
        "I'm so happy to see you happy.",
        Colors.green,
        "😊"
      ); // Happy message
    } else if (totalSad == maxCount) {
      return (
        "You need to get away from what's bothering you.",
        Colors.blue, // Color for sad mood
        "😞" // Emoji for sad
      );
    } else {
      return (
        "Do you really need to get so angry?",
        Colors.red,
        "😠"
      ); // Angry message
    }
  }
}