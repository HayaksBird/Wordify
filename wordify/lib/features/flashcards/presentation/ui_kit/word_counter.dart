import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';

///
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