// Import necessary packages for Flutter and number formatting
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../journaling/viewmodel/journal_viewmodel.dart';

// TotalStepsCard widget to display the total number of steps
class TotalStepsCard extends StatelessWidget {
  final JournalingViewModel viewModel; // ViewModel for managing journal data

  const TotalStepsCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    // Calculate the total number of steps from the viewModel
    final totalSteps = viewModel.calculateTotalSteps();
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Rounded corners for the card
      child: Container(
        color: Colors.blueGrey
            .withOpacity(0.5), // Semi-transparent background color
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding inside the card
          child: Column(
            children: [
              const Text(
                "Total Steps", // Title of the card
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white), // Title text style
              ),
              const SizedBox(height: 8), // Space between title and steps
              Text(
                "${NumberFormat.decimalPattern().format(totalSteps)} 👣", // Display total steps with emoji
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold), // Steps text style
              ),
            ],
          ),
        ),
      ),
    );
  }
}