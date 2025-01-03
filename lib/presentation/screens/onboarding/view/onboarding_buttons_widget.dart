
// Import necessary packages for Flutter and routing
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// OnboardingButtons widget to manage navigation buttons during onboarding
class OnboardingButtons extends StatelessWidget {
  final int currentPage; // Current page index
  final int totalPages; // Total number of pages
  final PageController pageController; // Controller for page navigation

  const OnboardingButtons({
    required this.currentPage,
    required this.totalPages,
    required this.pageController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.of(context).size; // Get screen size for responsive design

    return Stack(
      children: [
        // Previous Button (Hidden on the first page, visible on the second and third pages)
        if (currentPage != 0 && currentPage != 2)
          Positioned(
            bottom: size.height * 0.05, // Position from the bottom
            left: size.width * 0.1, // Position from the left
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the previous page
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 180, 175, 157), // Button color
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, // Horizontal padding
                  vertical: size.height * 0.02, // Vertical padding
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
              ),
              child: Text(
                "Previous", // Button label
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      size.width * 0.04, // Font size based on screen width
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        // Next Button (Visible only on the first two pages)
        if (currentPage != 2)
          Positioned(
            right: size.width * 0.04, // Position from the right
            bottom: size.height * 0.05, // Position from the bottom
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the next page
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 100, 96, 85), // Button color
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, // Horizontal padding
                  vertical: size.height * 0.02, // Vertical padding
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
              ),
              child: Text(
                "Next", // Button label
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      size.width * 0.04, // Font size based on screen width
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        // Start Journaling Button (Visible on the last page)
        if (currentPage == 2)
          Positioned(
            right: size.width * 0.05, // Position from the right
            bottom: size.height * 0.05, // Position from the bottom
            child: ElevatedButton(
              onPressed: () =>
                  context.go('/journal'), // Navigate to the journal page
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 100, 96, 85), // Button color
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, // Horizontal padding
                  vertical: size.height * 0.02, // Vertical padding
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
              ),
              child: Text(
                "Start Journaling", // Button label
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      size.width * 0.04, // Font size based on screen width
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
