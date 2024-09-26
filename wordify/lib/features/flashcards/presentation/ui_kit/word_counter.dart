import 'package:flutter/material.dart';
import 'package:wordify/core/presentation/ui_kit/colors.dart';

///The counter that shows the total word count in the current flashcards set
///and the current word's position.
class WordCounter extends StatelessWidget {
  final int currentWordPos, totalWordCount;

  const WordCounter({
    super.key,
    required this.currentWordPos,
    required this.totalWordCount
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$currentWordPos/$totalWordCount',
      style: const TextStyle(
        color: AppColors.text,
        fontSize: 20
      )
    );
  }
}