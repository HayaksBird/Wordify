import 'package:flutter/material.dart';
import 'package:wordify/core/presentation/animation_kit/fade_appearance.dart';
import 'package:wordify/core/presentation/ui_kit/colors.dart';

class WordTileWidget extends StatelessWidget {
  final String word, translation;
  final String? sentence;
  final bool isSelected;
  final bool showSentence;


  const WordTileWidget({
    super.key,
    required this.word,
    required this.translation,
    this.sentence,
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
              word,
              style: const TextStyle(
                color: AppColors.text,
              )
            ),
            subtitle: Text( //Show word's translation
              translation,
              style: const TextStyle(
                color: AppColors.text,
              ),
            )
          )
        ),

        FadeAppearance(
          isVisible: showSentence && sentence != null && sentence != '',
          child: Container(
            color: isSelected ? AppColors.backgroundMain : null,
            child: ListTile(
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text( //Show word's corresponding sentence
                  sentence!,
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