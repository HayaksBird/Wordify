import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/core/presentation/ui_kit/colors.dart';

///The front content of the flashcard
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