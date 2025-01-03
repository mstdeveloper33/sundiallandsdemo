
// Import necessary packages for Flutter, swiper functionality, and date formatting
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/journal_entry_model.dart';
import '../viewmodel/journal_viewmodel.dart';

// JournalSwiper widget to display journal entries in a swipeable format
class JournalSwiper extends StatelessWidget {
  final JournalingViewModel viewModel; // ViewModel for managing journal data

  const JournalSwiper({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    // Check if there are no journal entries
    if (viewModel.journalEntries.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height *
            0.40, // Set height for empty state
        child: const Center(
          child: Text(
            'To get better, you have to start.', // Message for empty state
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    // If there is only one journal entry, display it directly
    if (viewModel.journalEntries.length == 1) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.40,
        child: _buildCard(
            context, viewModel.journalEntries[0], false), // Build single card
      );
    }

    // Display multiple journal entries in a swiper
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      child: Swiper(
        itemCount:
            viewModel.journalEntries.length, // Number of entries to display
        itemBuilder: (context, index) {
          return _buildCard(context, viewModel.journalEntries[index],
              true); // Build card for each entry
        },
        viewportFraction: 0.85, // Fraction of the viewport to show
        scale: 0.9, // Scale of the cards
      ),
    );
  }

  // Method to build a card for a journal entry
  Widget _buildCard(
      BuildContext context, JournalEntry entry, bool isSwipeable) {
    final date = DateTime.parse(entry.date); // Parse the entry date

    return GestureDetector(
      onTap: () {
        // Show modal bottom sheet when the card is tapped
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return _buildExpandedCard(context, entry); // Build expanded card
          },
        );
      },
      child: Card(
        elevation: 8, // Elevation for shadow effect
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Rounded corners for the card
        ),
        child: Container(
          padding: const EdgeInsets.all(16), // Padding inside the card
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(20), // Rounded corners for the container
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getMoodColor(entry.mood)
                    .withOpacity(0.6), // Gradient color based on mood
                _getMoodColor(entry.mood).withOpacity(0.2),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align children to the start
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Space between date and mood
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy').format(date), // Format the date
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    entry.mood, // Display the mood emoji
                    style: const TextStyle(fontSize: 25),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Space below the date and mood
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(
                      16), // Padding for the text container
                  child: Text(
                    entry.text, // Display the journal entry text
                    maxLines: 5, // Limit to 5 lines
                    overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build an expanded card for a journal entry
  Widget _buildExpandedCard(BuildContext context, JournalEntry entry) {
    final date = DateTime.parse(entry.date); // Parse the entry date
    final formattedTime = DateFormat('hh:mm a').format(date); // Format the time

    return Container(
      height: MediaQuery.of(context).size.height *
          0.6, // Height for the expanded card
      padding: const EdgeInsets.all(16), // Padding inside the expanded card
      decoration: BoxDecoration(
        color: _getMoodColor(entry.mood), // Background color based on mood
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20)), // Rounded top corners
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to the start
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Space between date and mood
            children: [
              Text(
                DateFormat('MMM dd, yyyy').format(date), // Format the date
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                entry.mood, // Display the mood emoji
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Space below the date and mood
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                entry.text, // Display the journal entry text
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5), // Space below the text
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Space between time and action buttons
            children: [
              Text(
                formattedTime, // Display the formatted time
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit,
                        color: Colors.white), // Edit button
                    onPressed: () {
                      // Edit action
                      Navigator.pop(context); // Close the modal
                      viewModel
                          .editEntry(entry); // Call edit method in ViewModel
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.white), // Delete button
                    onPressed: () async {
                      await viewModel
                          .deleteEntry(entry.id!); // Delete the entry
                      Navigator.pop(context); // Close the modal
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to get the color associated with a mood
  Color _getMoodColor(String mood) {
    switch (mood) {
      case "😊":
        return Colors.green; // Happy mood
      case "😞":
        return Colors.blue; // Sad mood
      case "😠":
        return Colors.orange; // Angry mood
      default:
        return Colors.purple; // Default color for unknown moods
    }
  }
}
