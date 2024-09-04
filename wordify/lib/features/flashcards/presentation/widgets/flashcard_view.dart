import 'package:flutter/material.dart';
import 'package:wordify/features/flashcards/domain/entities/word.dart';
import 'package:wordify/features/flashcards/presentation/state_management/flashcards_bloc.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/background.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/header.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/navigation.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/word_card.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/word_rating.dart';

///
class FlashcardView extends StatelessWidget {
  final WordContentStats word;
  final Header header;
  final WordRating wordRating;
  final int rating;
  final _flashcardsBloc = FlashcardsBloc();


  FlashcardView({
    super.key,
    required this.word,
    required this.wordRating,
    required this.header,
    required this.rating
  });


  @override
  Widget build(BuildContext context) {
    return Background(
      child: Stack(
        children: [
          WordCard(
            word: word.word,
            wordRating: wordRating
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: header
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Navigation(
              goBack: () { _flashcardsBloc.setPreviousWord(word, rating); },
              goForward: () { _flashcardsBloc.setNextWord(word, rating); },
              currentWordPos: _flashcardsBloc.currentWordPos,
              wordsInTotal: _flashcardsBloc.wordsInTotal
            )
          )
        ]
      )
    );
  }
}