import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/features/flashcards/domain/use_cases/assets.dart';
import 'package:wordify/features/flashcards/presentation/state_management/chosen_rating_provider.dart';
import 'package:wordify/features/flashcards/presentation/state_management/flashcards_bloc.dart';
import 'package:wordify/features/flashcards/presentation/widgets/flashcard_view.dart';
import 'package:wordify/features/flashcards/presentation/ui_kit/header.dart';

///Show the page with the flashcards.
class ShowFlashcardPage extends StatefulWidget {
  final List<WordContentStats> words;
  final String path;


  const ShowFlashcardPage({
    super.key,
    required this.words,
    required this.path
  });


  @override
  State<ShowFlashcardPage> createState() => _ShowFlashcardPageState();
}

class _ShowFlashcardPageState extends State<ShowFlashcardPage> {
  final _flashcardsBloc = FlashcardsBloc();
  

  @override
  void dispose() {
    super.dispose();
    _flashcardsBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    _flashcardsBloc.flashcardsSetup(widget.words);
    
    return StreamBuilder<WordWithRating>(
      stream: _flashcardsBloc.wordInView,
      builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          WordContentStats word = snapshot.data!.word;

          return Scaffold(
            body: ChosenRatingProvider(
              notifier: ValueNotifier<int>(snapshot.data!.givenRating),
              child: Builder(
                builder: (context) {
                  final ValueNotifier<int> valueNotifier = ChosenRatingProvider.of(context);
              
                  return FlashcardView(
                    word: word,
                    maxRating: maxRating,
                    ratingNotifier: valueNotifier,
                    header: Header(
                      path: widget.path,
                      delimiter: '/'
                    )
                  );
                }
              )
            )
          );
        }
      }
    );
  }
}