import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/core/presentation/ui_kit/colors.dart';

class WordCardBackText extends StatelessWidget {
  final WordContentStats word;


  const WordCardBackText({
    super.key,
    required this.word
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              word.word,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 27,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 12),
            _cardTextBold('Translation'),
            _cardText(word.translation),
            if (word.sentence != null && word.sentence != '') ...[
              const SizedBox(height: 10),
              _cardTextBold('Example'),
              _cardText(word.sentence!)
            ]
          ]
        ),
      ),
    );
  }


  ///
  Widget _cardTextBold(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.text,
        fontSize: 15,
        fontWeight: FontWeight.w300
      )
    );
  }


  ///
  Widget _cardText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.text,
        fontSize: 20
      )
    );
  }
}