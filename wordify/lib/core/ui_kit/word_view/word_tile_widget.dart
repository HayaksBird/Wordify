import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';

class WordTileWidget extends StatelessWidget {
  final String word, translation;
  final bool isSelected;


  const WordTileWidget({
    super.key,
    required this.word,
    required this.translation,
    this.isSelected = false
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: isSelected ? AppColors.backgroundMain : null,
          child: ListTile(
            title: Text(
              word,
              style: const TextStyle(
                color: AppColors.text,
              ),
            ),
            subtitle: Text(
              translation,
              style: const TextStyle(
                color: AppColors.text,
              ),
            ),
          ),
        ),

        if (!isSelected)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(
              color: AppColors.navigationSecondary,
              height: 0,
              thickness: 0.1,
            ),
          )
      ],
    );
  }
}