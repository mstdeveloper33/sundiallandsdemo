// Import necessary packages for Flutter
import 'package:flutter/material.dart';

// MoodLegend widget to display mood indicators with corresponding colors
class MoodLegend extends StatelessWidget {
  const MoodLegend({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double horizontalMargin =
        screenWidth * 0.3; // Horizontal margin for the container
    double verticalMargin =
        screenHeight * 0.001; // Vertical margin for the container

    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: verticalMargin,
            horizontal: horizontalMargin), // Set margins
        width: double.infinity, // Full width
        padding: const EdgeInsets.all(10), // Padding inside the container
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align children to the start
          children: [
            // Build mood indicators for happy, sad, and angry moods
            _buildMoodIndicator("😊",
                const LinearGradient(colors: [Colors.lime, Colors.green])),
            _buildMoodIndicator("😞",
                const LinearGradient(colors: [Colors.lightBlue, Colors.blue])),
            _buildMoodIndicator("😠",
                const LinearGradient(colors: [Colors.redAccent, Colors.red])),
          ],
        ),
      ),
    );
  }

  // Private method to build a mood indicator with a gradient
  Widget _buildMoodIndicator(String mood, Gradient gradient) {
    return Row(
      children: [
        Text(mood, style: const TextStyle(fontSize: 15)), // Display mood emoji
        const SizedBox(width: 20), // Space between emoji and line
        Container(
          height: 3, // Height of the indicator line
          width: 50, // Width of the indicator line
          decoration: BoxDecoration(
            gradient: gradient, // Set gradient for the line
            borderRadius: BorderRadius.circular(2), // Rounded corners
          ),
        ),
      ],
    );
  }
}