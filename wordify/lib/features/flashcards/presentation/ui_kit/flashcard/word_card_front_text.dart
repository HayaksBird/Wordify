import 'package:flutter/material.dart';
import 'package:wordify/core/presentation/ui_kit/colors.dart';
import 'package:wordify/features/flashcards/domain/entities/word.dart';

class WordCardFrontText extends StatelessWidget {
  final WordContentStats word;


  const WordCardFrontText({
    super.key,
    required this.word
  });


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        word.translation,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 40
        )
      ),
    );
  }
}