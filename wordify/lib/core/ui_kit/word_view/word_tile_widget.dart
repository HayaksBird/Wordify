import 'package:flutter/material.dart';
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showSentence && word.sentence != null)...[
                  const SizedBox(height: 3.5)
                ],

                Text( //Show the word itself
                  word.word,
                  style: const TextStyle(
                    color: AppColors.text,
                  ),
                ),
              ]
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( //Show word's translation
                  word.translation,
                  style: const TextStyle(
                    color: AppColors.text,
                  ),
                ),
                
                if (showSentence && word.sentence != null)...[
                  const SizedBox(height: 20.0),
          
                  Text( //Show word's corresponding sentence
                    word.sentence!,
                    style: const TextStyle(
                      color: AppColors.text,
                    ),
                  ),
                ]
              ]
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
            ),
          )
      ],
    );
  }
}