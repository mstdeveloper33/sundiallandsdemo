// Import necessary packages for Flutter and percent indicator
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../viewmodel/journal_viewmodel.dart';
import 'motivational_card.dart';

// HealthCards widget to display health metrics such as steps and heart rate
class HealthCards extends StatelessWidget {
  final JournalingViewModel viewModel; // ViewModel for managing health data

  const HealthCards({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.of(context).size; // Get screen size for responsive design

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Step Count Card
            Container(
              padding: const EdgeInsets.all(5),
              width: size.width * 0.25, // Set width based on screen size
              child: Column(
                children: [
                  CircularPercentIndicator(
                    radius: 50.0, // Radius of the circular indicator
                    lineWidth: 8.0, // Width of the line
                    animation: true, // Enable animation
                    animationDuration: 1000, // Duration of the animation
                    percent: _calculateStepPercentage(
                        viewModel.getCurrentDayHealthMetrics()?.steps ??
                            0), // Calculate step percentage
                    center: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (viewModel.getCurrentDayHealthMetrics()?.steps ??
                                      0) >=
                                  10000
                              ? "${viewModel.getCurrentDayHealthMetrics()?.steps.toString() ?? "0"} 🎉" // Celebrate if steps are 10,000 or more
                              : viewModel
                                      .getCurrentDayHealthMetrics()
                                      ?.steps
                                      .toString() ??
                                  "0",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getProgressColor(viewModel
                                .calculateTotalSteps()), // Get color based on total steps
                          ),
                        ),
                        const Text('Steps 👣',
                            style: TextStyle(fontSize: 13)), // Label for steps
                      ],
                    ),
                    circularStrokeCap:
                        CircularStrokeCap.round, // Round stroke cap
                    progressColor: _getProgressColor(
                        viewModel.getCurrentDayHealthMetrics()?.steps ??
                            0), // Set progress color
                    backgroundColor:
                        Colors.grey[200]!, // Background color of the indicator
                  ),
                ],
              ),
            ),

            // Heart Rate Card
            Container(
              padding: const EdgeInsets.all(5),
              width: size.width * 0.30, // Set width based on screen size
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), // Rounded corners
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF6B6B), // Gradient color 1
                    Color(0xFFFF8E8E), // Gradient color 2
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Heart Rate', // Title of the heart rate card
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                      height: 10), // Space between title and heart rate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.favorite,
                          color: Colors.white, size: 28), // Heart icon
                      const SizedBox(width: 8), // Space between icon and text
                      Text(
                        '${viewModel.getCurrentDayHealthMetrics()?.heartRate ?? 0}', // Get current heart rate
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        ' bpm', // Label for heart rate
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Space below the row of cards
        // Motivational Card
        MotivationalCard(viewModel: viewModel), // Display motivational card
      ],
    );
  }

  // Method to calculate the step percentage based on a target of 10,000 steps
  double _calculateStepPercentage(int steps) {
    double percentage =
        steps / 10000; // Calculate percentage based on 10,000 steps
    return percentage > 1.0
        ? 1.0 // Cap the percentage at 1.0
        : percentage; // Return the calculated percentage
  }

  // Method to get the progress color based on the number of steps
  Color _getProgressColor(int steps) {
    double percentage =
        steps / 10000; // Calculate percentage based on 10,000 steps

    if (steps >= 10000) {
      return Colors.green; // Green for 10,000 or more steps
    } else if (percentage >= 0.75) {
      return Colors.lightGreen; // Light green for 75% or more
    } else if (percentage >= 0.5) {
      return Colors.yellow; // Yellow for 50% or more
    } else if (percentage >= 0.25) {
      return Colors.orange; // Orange for 25% or more
    } else {
      return Colors.red; // Red for less than 25%
    }
  }
}