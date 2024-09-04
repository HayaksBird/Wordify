import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/word_rating.dart';

///The flashcard itself with a word and the rating bar.
class WordCard extends StatelessWidget {
  final String word;
  final WordRating wordRating;


  const WordCard({
    super.key,
    required this.word,
    required this.wordRating
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.symmetric(vertical: 140.0, horizontal: 120.0),
      child: Stack(
        children: [
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            color: AppColors.primary,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Text(
                  word,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 40
                  )
                )
              ),
            ),
          ),
          Positioned(
            bottom: 8.0,
            left: 0,
            right: 0,
            child: Center(child: wordRating),
          )
        ],
      ),
    );
  }
}