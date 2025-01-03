// Import necessary packages for Flutter and the journaling ViewModel
import 'package:flutter/material.dart';
import '../../journaling/viewmodel/journal_viewmodel.dart';

// ViewModel class for managing dashboard data and state
class DashboardViewModel extends ChangeNotifier {
  final JournalingViewModel
      journalingViewModel; // Reference to the journaling ViewModel

  // Constructor to initialize the journaling ViewModel
  DashboardViewModel(this.journalingViewModel);

  // Method to load data from the journaling ViewModel
  void loadData() {
    journalingViewModel.loadEntries(); // Load journal entries
    journalingViewModel.loadHealthMetrics(); // Load health metrics
  }

  // Getter to calculate total steps from the journaling ViewModel
  int get totalSteps => journalingViewModel.calculateTotalSteps();

  // Getter to retrieve mood counts for the current week from the journaling ViewModel
  Map<String, Map<int, int>> get moodCounts =>
      journalingViewModel.getMoodCountsForCurrentWeek();
}