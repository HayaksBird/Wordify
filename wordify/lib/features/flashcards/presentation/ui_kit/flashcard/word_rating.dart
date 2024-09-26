import 'package:flutter/material.dart';
import 'package:wordify/core/presentation/ui_kit/colors.dart';

///The rating of a word given by the user that
///indicates the performance in translating it.
class WordRating extends StatelessWidget {
  final int maxRating, chosenRating;
  final ValueNotifier<int> valueNotifier;


  const WordRating({
    super.key,
    required this.maxRating,
    required this.chosenRating,
    required this.valueNotifier
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Adjust row width to content
      children: List.generate(maxRating, (index) {
        return IconButton(
          onPressed: () {
            valueNotifier.value = index + 1;
          },
          icon: Icon(
            index < chosenRating ? Icons.star : Icons.star_border,
            color: AppColors.text,
          ),
        );
      }),
    );
  }
}