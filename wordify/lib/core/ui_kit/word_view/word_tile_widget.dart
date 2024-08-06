import 'package:flutter/material.dart';
import 'package:wordify/core/animation_kit/fade_appearance.dart';
import 'package:wordify/core/ui_kit/colors.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';

class WordTileWidget extends StatelessWidget {
  final Word word;
  final bool isSelected;
  final bool showSentence;


  const WordTileWidget({
    super.key,
    required this.word,
    this.isSelected = false,
    this.showSentence = false
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: isSelected ? AppColors.backgroundMain : null,
          child: ListTile(
            title: Text( //Show the word itself
              word.word,
              style: const TextStyle(
                color: AppColors.text,
              )
            ),
            subtitle: Text( //Show word's translation
              word.translation,
              style: const TextStyle(
                color: AppColors.text,
              ),
            )
          )
        ),

        FadeAppearance(
          isVisible: showSentence && word.sentence != null && word.sentence != '',
          child: Container(
            color: isSelected ? AppColors.backgroundMain : null,
            child: ListTile(
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text( //Show word's corresponding sentence
                  word.sentence!,
                  style: const TextStyle(
                    color: AppColors.text
                  )
                ),
              )
            ),
          ),
        ),

        if (!isSelected)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(
              color: AppColors.navigationSecondary,
              height: 0,
              thickness: 0.15,
            )
          )
      ]
    );
  }
}