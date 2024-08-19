import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/core/ui_kit/colors.dart';
import 'package:wordify/features/flashcards/domain/entities/word.dart';
import 'package:wordify/features/flashcards/presentation/state_management/flashcards_bloc.dart';

class ShowFlashcardPage extends StatefulWidget {
  final List<WordContentStats> words;


  const ShowFlashcardPage({
    super.key,
    required this.words
  });


  @override
  State<ShowFlashcardPage> createState() => _ShowFlashcardPageState();
}

class _ShowFlashcardPageState extends State<ShowFlashcardPage> {
  final _flashcardsBloc = FlashcardsBloc();


  @override
  void initState() {
    super.initState();
    _flashcardsBloc.flashcardsSetup(widget.words);
  }


  @override
  void dispose() {
    super.dispose();
    _flashcardsBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WordContentStats>(
      stream: _flashcardsBloc.wordInView,
      builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          WordContentStats word = snapshot.data!;

          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  Text(
                    word.word,
                    style: const TextStyle(color: AppColors.text)
                  ),
                  Text(
                    word.translation,
                    style: const TextStyle(color: AppColors.text)
                  ),
                  Text(
                    word.sentence ?? '',
                    style: const TextStyle(color: AppColors.text)
                  ),
                  WordifyElevatedButton(
                    text: 'Next',
                    onPressed: () { _flashcardsBloc.setNextWord(); },
                  )
                ],
              ),
            ),
          );
        }
      }
    );
  }
}