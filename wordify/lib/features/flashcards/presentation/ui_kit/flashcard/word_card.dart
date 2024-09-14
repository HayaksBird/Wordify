import 'package:flutter/material.dart';
import 'package:wordify/core/presentation/ui_kit/colors.dart';

///The flashcard itself with a word and the rating bar.
class WordCard extends StatelessWidget {
  final Widget content;
  final Widget wordRating;


  const WordCard({
    super.key,
    required this.content,
    required this.wordRating
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 140.0, horizontal: 120.0),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              color: AppColors.primary,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: content
              )
            )
          ),
          Positioned(
            bottom: 8.0,
            left: 0,
            right: 0,
            child: Center(child: wordRating),
          )
        ]
      )
    );
  }
}