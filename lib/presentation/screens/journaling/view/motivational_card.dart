
import 'package:flutter/material.dart';
import '../viewmodel/journal_viewmodel.dart';

class MotivationalCard extends StatelessWidget {
  final JournalingViewModel viewModel;

  const MotivationalCard({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final motivationalMessage = viewModel.getCurrentDayMotivationalMessage();

    return Center(
      child: Card(
        color: const Color.fromARGB(255, 65, 67, 97),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            motivationalMessage?.message ?? "Make today amazing!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}