import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/features/flashcards/presentation/animation_kit/flip_card.dart';
import 'package:wordify/features/flashcards/presentation/animation_kit/switch_card.dart';
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
  final ValueNotifier<int> ratingNotifier;
  final _flashcardsBloc = FlashcardsBloc();


  FlashcardView({
    super.key,
    required this.word,
    required this.header,
    required this.maxRating,
    required this.ratingNotifier
  });


  @override
  Widget build(BuildContext context) {
    final flipCardController = FlipCardController();
    final switchCardController = SwitchCardController();


    return Background(
      child: Stack(
        children: [
           ValueListenableBuilder<int>(
            valueListenable: ratingNotifier,
            builder: (context, rating, child) {
              return GestureDetector(
                onPanEnd: (details) {
                  final velocity = details.velocity.pixelsPerSecond;
              
                  //swipe left (go forward).
                  if (velocity.dx < 0) {
                    switchCardController.slideRight();
                    _flashcardsBloc.setNextWord(word, ratingNotifier.value);
                  }
              
                  //swipe right (go back).
                  if (velocity.dx > 0) {
                    switchCardController.slideLeft();
                    _flashcardsBloc.setPreviousWord(word, ratingNotifier.value);
                  }
                },
              
                onTap: () {
                  flipCardController.flipCard();
                },

                child: SwitchCard(
                  controller: switchCardController,
                  identifier: word,
                  child: FlipCard(
                    key: ValueKey(word),
                    controller: flipCardController,
                    front: WordCard(
                      content: WordCardFrontText(word: word),
                      wordRating: WordRating(
                        maxRating: maxRating,
                        chosenRating: rating,
                        valueNotifier: ratingNotifier
                      )
                    ),
                    back: WordCard(
                      content: WordCardBackText(word: word),
                      wordRating: WordRating(
                        maxRating: maxRating,
                        chosenRating: rating,
                        valueNotifier: ratingNotifier
                      )
                    )
                  ),
                )
              );
            } 
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
              goBack: () {
                switchCardController.slideLeft();
                _flashcardsBloc.setPreviousWord(word, ratingNotifier.value);
              },
              goForward: () {
                switchCardController.slideRight();
                _flashcardsBloc.setNextWord(word, ratingNotifier.value);
              },
              currentWordPos: _flashcardsBloc.currentWordPos,
              wordsInTotal: _flashcardsBloc.wordsInTotal
            )
          )
        ]
      )
    );
  }
}