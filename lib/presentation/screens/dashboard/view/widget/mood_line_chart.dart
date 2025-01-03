// Import necessary packages for charting and date formatting
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../journaling/viewmodel/journal_viewmodel.dart';

// MoodLineChart widget to display mood trends over the week
class MoodLineChart extends StatelessWidget {
  final JournalingViewModel viewModel; // ViewModel for managing journal data

  const MoodLineChart({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    // Get the dates for the current week
    final List<DateTime> weekDates = getWeekDates();
    // Get mood counts for the current week
    final moodCounts = viewModel.getMoodCountsForCurrentWeek();
    // Calculate the maximum Y value dynamically based on mood counts
    double dynamicMaxY = _calculateDynamicMaxY(moodCounts);

    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 20),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            // Create mood bars for happy, sad, and angry moods
            _createMoodBar("😊", moodCounts["😊"] ?? {},
                const LinearGradient(colors: [Colors.lime, Colors.green])),
            _createMoodBar("😞", moodCounts["😞"] ?? {},
                const LinearGradient(colors: [Colors.lightBlue, Colors.blue])),
            _createMoodBar("😠", moodCounts["😠"] ?? {},
                const LinearGradient(colors: [Colors.redAccent, Colors.red])),
          ],
          borderData: FlBorderData(
            border: const Border(
              bottom: BorderSide(color: Colors.grey, width: 1),
              left: BorderSide(color: Colors.grey, width: 1),
              right: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            ),
          ),
          minX: 0, // Minimum X value (days of the week)
          maxX: 6, // Maximum X value (days of the week)
          maxY: dynamicMaxY, // Maximum Y value (mood count)
          minY: 0, // Minimum Y value
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 65,
                showTitles: true,
                getTitlesWidget: (value, meta) => bottomTitleWidgets(
                    value, meta, weekDates), // Custom bottom titles
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString(),
                      style: const TextStyle(
                          fontSize: 12, color: Colors.white)); // Y-axis labels
                },
                reservedSize: 40,
                interval: 1,
              ),
            ),
          ),
          gridData: const FlGridData(
              verticalInterval: 1,
              horizontalInterval: 1,
              show: true), // Show grid lines
          lineTouchData: lineTouchData, // Touch interaction settings
        ),
      ),
    );
  }

  // Method to get the dates for the current week
  List<DateTime> getWeekDates() {
    final DateTime now = DateTime.now();
    return List.generate(
        7, (index) => now.subtract(Duration(days: 5 - index))); // Last 7 days
  }

  // Method to calculate the maximum Y value dynamically
  double _calculateDynamicMaxY(Map<String, Map<int, int>> moodCounts) {
    int maxMoodCount = moodCounts.values
        .expand((countMap) => countMap.values)
        .fold(
            0,
            (previous, current) => current > previous
                ? current
                : previous); // Find the maximum count
    return (maxMoodCount + 4)
        .toDouble(); // Add a buffer for better visualization
  }

  // Method to create a mood bar for the line chart
  LineChartBarData _createMoodBar(
      String mood, Map<int, int> moodCounts, Gradient gradient) {
    return LineChartBarData(
      spots: generateSpots(moodCounts), // Generate spots for the mood counts
      isCurved: true, // Make the line curved
      gradient: gradient, // Set the gradient color
      preventCurveOverShooting: true, // Prevent overshooting of the curve
      barWidth: 4, // Width of the line
      dotData: const FlDotData(show: true), // Show dots on the line
      belowBarData: BarAreaData(show: false), // Do not show area below the line
    );
  }

  // Method to generate spots for the line chart based on mood counts
  List<FlSpot> generateSpots(Map<int, int> moodCounts) {
    return List.generate(7, (index) {
      int dayIndex = index + 1; // Day index (1-7)
      double count =
          moodCounts[dayIndex]?.toDouble() ?? 0; // Get count for the day
      return FlSpot(
          index.toDouble(), count.clamp(0, double.infinity)); // Create FlSpot
    });
  }

  // Method to create bottom titles for the X-axis
  Widget bottomTitleWidgets(
      double value, TitleMeta meta, List<DateTime> weekDates) {
    int dayIndex = value.toInt(); // Get the day index
    if (dayIndex < 0 || dayIndex >= weekDates.length)
      return const Text(''); // Return empty if out of range
    final DateTime date = weekDates[dayIndex]; // Get the corresponding date

    // Format the date and weekday name
    final String formattedDate = DateFormat('d').format(date);
    final String weekDayName = DateFormat('EEE').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Column(
        children: [
          Text(formattedDate,
              style: const TextStyle(
                  fontSize: 12, color: Colors.white)), // Display date
          Text('/$weekDayName',
              style: const TextStyle(
                  fontSize: 12, color: Colors.white)), // Display weekday
        ],
      ),
    );
  }

  // Method to configure line touch interactions
  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              String emoji; // Emoji based on the mood
              switch (spot.barIndex) {
                case 0:
                  emoji = '😊'; // Happy
                  break;
                case 1:
                  emoji = '😞'; // Sad
                  break;
                case 2:
                  emoji = '😠'; // Angry
                  break;
                default:
                  emoji = '';
              }
              return LineTooltipItem('$emoji: ${spot.y.toInt()}',
                  const TextStyle(color: Colors.white)); // Tooltip display
            }).toList();
          },
        ),
      );
}