
// Import necessary packages for Flutter and state management
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import 'onboarding_buttons_widget.dart';
import 'onboarding_page.dart';

// Onboarding view widget to guide users through the app
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController =
      PageController(); // Controller for page navigation
  int _currentPage = 0; // Current page index

  @override
  void initState() {
    super.initState();
    // Load motivational messages when the onboarding view is initialized
    final viewModel = Provider.of<OnboardingViewModel>(context, listen: false);
    viewModel.loadMotivationalMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, child) {
        // Get the first motivational message or show loading text
        final motivationalMessage =
            viewModel.motivationalMessages?.isNotEmpty == true
                ? viewModel.motivationalMessages!.first.message
                : "Loading...";

        // Define the onboarding pages
        final pages = [
          const OnboardingPage(
            title: "Welcome", // Title for the first page
            content:
                "Track your health and mental well-being effortlessly!", // Content for the first page
            color: Color(0xFFA0D4CF), // Background color for the first page
            imagePath:
                'lib/assets/onboardingimages/health.png', // Image for the first page
          ),
          const OnboardingPage(
            title: "", // Title for the second page
            content:
                "Ready to journal? Let's get started!", // Content for the second page
            color: Color(0xFFD0C7BA), // Background color for the second page
            imagePath:
                'lib/assets/onboardingimages/diary.png', // Image for the second page
          ),
          OnboardingPage(
            title: "", // Title for the third page
            content:
                motivationalMessage, // Content for the third page (motivational message)
            color:
                const Color(0xFFE1DDCC), // Background color for the third page
            imagePath:
                'lib/assets/onboardingimages/motivation.png', // Image for the third page
          ),
        ];

        return Scaffold(
          body: Stack(
            children: [
              // PageView to display onboarding pages
              PageView.builder(
                controller: _pageController, // Controller for the PageView
                itemCount: pages.length, // Number of pages
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index; // Update current page index
                  });
                },
                itemBuilder: (context, index) {
                  return pages[index]; // Return the corresponding page
                },
                physics:
                    const NeverScrollableScrollPhysics(), // Disable swipe gestures
              ),
              // Onboarding buttons for navigation
              OnboardingButtons(
                currentPage: _currentPage, // Current page index
                totalPages: pages.length, // Total number of pages
                pageController:
                    _pageController, // Page controller for navigation
              ),
            ],
          ),
        );
      },
    );
  }
}
