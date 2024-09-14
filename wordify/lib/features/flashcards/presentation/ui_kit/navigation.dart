import 'package:flutter/material.dart';
import 'package:wordify/core/presentation/ui_kit/buttons.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/word_counter.dart';

///
class Navigation extends StatelessWidget {
  final void Function() goBack, goForward;
  final int currentWordPos, wordsInTotal;

  const Navigation({
    super.key,
    required this.goBack,
    required this.goForward,
    required this.currentWordPos,
    required this.wordsInTotal
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 120.0, right: 120.0, bottom: 60.0),
      child: Row(
        children: [
          NavigationBackButton(
            text: 'Previous',
            goBack: goBack
          ),
          const Spacer(),
          WordCounter(
            currentWordPos: currentWordPos,
            totalWordCount: wordsInTotal
          ),
          const Spacer(),
          NavigationForwardButton(
            text: 'Next',
            goForward: goForward
          )
        ]
      ),
    );
  }
}