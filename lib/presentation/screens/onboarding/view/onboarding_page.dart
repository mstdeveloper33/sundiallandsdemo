
// Import necessary packages for Flutter
import 'package:flutter/material.dart';

// OnboardingPage widget to display a single onboarding page
class OnboardingPage extends StatelessWidget {
  final String title; // Title of the onboarding page
  final String content; // Content description of the onboarding page
  final Color color; // Background color of the page
  final String imagePath; // Path to the image to be displayed

  const OnboardingPage({
    required this.title,
    required this.content,
    required this.color,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final size = MediaQuery.of(context).size;

    return Container(
      color: color, // Set the background color
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the content vertically
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    size.width * 0.1), // Horizontal padding for the image
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(20), // Rounded corners for the image
              child: Image.asset(
                imagePath,
                height:
                    size.height * 0.4, // Scale the image based on screen height
                fit: BoxFit.cover, // Cover the entire area
              ),
            ),
          ),
          SizedBox(height: size.height * 0.05), // Space between image and title
          Text(
            title, // Display the title
            style: TextStyle(
              fontSize:
                  size.width * 0.09, // Dynamic font size based on screen width
              fontWeight: FontWeight.bold,
              color: Colors.white, // Title text color
            ),
          ),
          SizedBox(
              height: size.height * 0.02), // Space between title and content
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    size.width * 0.1), // Horizontal padding for the content
            child: Text(
              content, // Display the content description
              textAlign: TextAlign.center, // Center align the text
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.width *
                    0.050, // Dynamic font size based on screen width
                color: Colors.white, // Content text color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
