// Import necessary packages for Flutter, routing, state management, and the journaling ViewModel
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../viewmodel/journal_viewmodel.dart';
import 'healt_cards.dart';
import 'journal_entry_form.dart';
import 'journal_swiper.dart';

// JournalingView widget for managing journal entries
class JournalingView extends StatefulWidget {
  const JournalingView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JournalingViewState createState() => _JournalingViewState();
}

class _JournalingViewState extends State<JournalingView> {
  @override
  void initState() {
    super.initState();
    // Fetch health metrics and motivational messages when the view is initialized
    final viewModel = Provider.of<JournalingViewModel>(context, listen: false);
    viewModel.fetchHealthMetrics();
    viewModel.fetchMotivationalMessages();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<JournalingViewModel>(context); // Get the ViewModel

    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard and cancel editing when tapping outside
        FocusScope.of(context).unfocus();
        viewModel.cancelEditing();
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF585A79), // Background color for the journaling view
        ),
        child: Scaffold(
          backgroundColor:
              Colors.transparent, // Transparent background for the scaffold
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent, // Transparent app bar
            centerTitle: true,
            title: const Text(
              "My Diary", // Title of the app bar
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.dashboard, // Dashboard icon
                  color: Colors.white,
                ),
                onPressed: () {
                  context.go('/dashboard'); // Navigate to the dashboard
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0), // Padding around the body
            child: Column(
              children: [
                JournalEntryForm(
                    viewModel: viewModel), // Form for entering journal entries
                const SizedBox(height: 16), // Space between form and swiper
                Expanded(
                    child: JournalSwiper(
                        viewModel:
                            viewModel)), // Swiper for displaying journal entries
                const SizedBox(
                    height: 16), // Space between swiper and health cards
                HealthCards(viewModel: viewModel), // Health metrics cards
              ],
            ),
          ),
        ),
      ),
    );
  }
}