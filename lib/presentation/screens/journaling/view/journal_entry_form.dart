// Import necessary packages for Flutter and the journaling ViewModel
import 'package:flutter/material.dart';
import '../viewmodel/journal_viewmodel.dart';
import 'mood_option.dart';

// JournalEntryForm widget for creating or updating journal entries
class JournalEntryForm extends StatelessWidget {
  final JournalingViewModel viewModel; // ViewModel for managing journal data

  const JournalEntryForm({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15), // Rounded corners for the form
      child: Container(
        decoration: const BoxDecoration(
          color:
              Color.fromARGB(255, 65, 67, 97), // Background color of the form
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Padding inside the form
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align children to the start
            children: [
              // Text field for journal entry input
              TextFormField(
                style: const TextStyle(color: Colors.white), // Text color
                controller:
                    viewModel.textController, // Controller for text input
                onChanged: (value) {
                  viewModel.updateJournalText(
                      value); // Update journal text in ViewModel
                },
                decoration: const InputDecoration(
                  labelText:
                      "Write your journal entry", // Label for the text field
                  labelStyle:
                      TextStyle(color: Colors.white), // Label text color
                  border: OutlineInputBorder(), // Border style
                ),
                maxLines: 3, // Maximum number of lines
                maxLength: 2000, // Maximum character length
              ),
              const SizedBox(
                  height: 16), // Space between text field and mood selection
              const Text(
                "Select your mood:", // Label for mood selection
                style: TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  // Mood options for user to select
                  MoodOption(viewModel: viewModel, mood: "😊"),
                  MoodOption(viewModel: viewModel, mood: "😞"),
                  MoodOption(viewModel: viewModel, mood: "😠"),
                  const Spacer(), // Spacer to push button to the right
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 58, 50, 106), // Button background color
                    ),
                    onPressed: viewModel.journalText
                            .isEmpty // Disable button if text is empty
                        ? null
                        : () async {
                            await viewModel
                                .saveEntry(); // Save the journal entry
                            viewModel.textController
                                .clear(); // Clear the text field after saving
                          },
                    child: Text(
                      viewModel.editingEntry == null
                          ? "Save Entry" // Button text for saving a new entry
                          : "Update Entry", // Button text for updating an existing entry
                      style: const TextStyle(
                          color: Colors.white), // Button text color
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}