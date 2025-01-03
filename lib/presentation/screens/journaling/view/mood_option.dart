
import 'package:flutter/material.dart';
import '../viewmodel/journal_viewmodel.dart';

class MoodOption extends StatelessWidget {
  final JournalingViewModel viewModel;
  final String mood;

  const MoodOption({Key? key, required this.viewModel, required this.mood})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => viewModel.updateMood(mood),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: viewModel.selectedMood == mood
                ? Colors.blueGrey
                : Colors.transparent,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          mood,
          style: TextStyle(
            fontSize: 24,
            color: viewModel.selectedMood == mood ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }
}
