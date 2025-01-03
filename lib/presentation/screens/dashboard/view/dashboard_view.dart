
// Import necessary packages for Flutter, routing, and state management
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../viewmodel/dashboard_viewmodel.dart';
import 'widget/highlight_card.dart';
import 'widget/mood_legend.dart';
import 'widget/mood_line_chart.dart';
import 'widget/total_steps_card.dart';

// Dashboard view widget displaying various health metrics
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the DashboardViewModel from the provider
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);
    final journalingViewModel = dashboardViewModel.journalingViewModel;

    // Load data when the dashboard is built
    dashboardViewModel.loadData();

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        context
            .go('/journal'); // Navigate to /journal page on back button press
        return false; // Prevent default back action
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 37, 84, 171), // Gradient color 1
              Color.fromARGB(255, 13, 36, 69), // Gradient color 2
              Color.fromARGB(255, 125, 142, 170), // Gradient color 3
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor:
              Colors.transparent, // Transparent background for the scaffold
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Transparent app bar
            elevation: 0, // No shadow
            centerTitle: true,
            title: const Text("Dashboard",
                style: TextStyle(color: Colors.white)), // Dashboard title
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Colors.white), // Back button
              onPressed: () {
                context
                    .go('/journal'); // Navigate to journal on back button press
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0), // Padding around the body
            child: Column(
              children: [
                const MoodLegend(), // Widget displaying mood legend
                Expanded(
                    child: MoodLineChart(
                        viewModel: journalingViewModel)), // Line chart for mood
                const SizedBox(height: 5), // Space between widgets
                HighlightCard(
                    viewModel:
                        journalingViewModel), // Highlight card for important metrics
                const SizedBox(height: 5), // Space between widgets
                TotalStepsCard(
                    viewModel:
                        journalingViewModel), // Card displaying total steps
                const SizedBox(height: 10), // Space below the last widget
              ],
            ),
          ),
        ),
      ),
    );
  }
}
