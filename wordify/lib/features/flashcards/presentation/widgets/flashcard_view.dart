import 'package:flutter/material.dart';
import 'package:wordify/features/flashcards/domain/entities/word.dart';
import 'package:wordify/features/flashcards/presentation/state_management/flashcards_bloc.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/background.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/flashcard/word_card_back_text.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/header.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/navigation.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/flashcard/word_card.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/flashcard/word_card_front_text.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/flashcard/word_rating.dart';

///
class FlashcardView extends StatelessWidget {
  final WordContentStats word;
  final Header header;
  final int maxRating;
  final ValueNotifier<bool> cardSideNotifier;
  final ValueNotifier<int> ratingNotifier;
  final _flashcardsBloc = FlashcardsBloc();


  FlashcardView({
    super.key,
    required this.word,
    required this.header,
    required this.maxRating,
    required this.cardSideNotifier,
    required this.ratingNotifier
  });


  @override
  Widget build(BuildContext context) {
    return Background(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () { cardSideNotifier.value = !cardSideNotifier.value; },
            child: ValueListenableBuilder<bool>(
              valueListenable: cardSideNotifier,
              builder: (context, isFrontSide, child) {
                return WordCard(
                  content: isFrontSide == true ?
                    WordCardFrontText(word: word) :
                    WordCardBackText(word: word),
                
                  wordRating: ValueListenableBuilder<int>(
                    valueListenable: ratingNotifier,
                    builder: (context, rating, child) {
                      return WordRating(
                        maxRating: maxRating,
                        chosenRating: rating,
                        valueNotifier: ratingNotifier
                      );
                    }
                  )
                );
              }
            )
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
              goBack: () { _flashcardsBloc.setPreviousWord(word, ratingNotifier.value); },
              goForward: () { _flashcardsBloc.setNextWord(word, ratingNotifier.value); },
              currentWordPos: _flashcardsBloc.currentWordPos,
              wordsInTotal: _flashcardsBloc.wordsInTotal
            )
          )
        ]
      )
    );
  }
}