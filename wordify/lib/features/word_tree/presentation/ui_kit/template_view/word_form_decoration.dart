import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/colors.dart';

///Custom TextFormField for Word.
class WordFormField extends TextFormField {
  WordFormField({
    super.key, 
    required TextEditingController super.controller,
    required super.validator,
    required String labelText
  }) : super(
          cursorColor: AppColors.text,
          decoration: WordInputDecoration(
            labelText: labelText
          ),
          style: const TextStyle(
            fontSize: 25,
            color: AppColors.text, // Set the desired color for the entered text
          ),
        );
}



///
class WordInputDecoration extends InputDecoration {
  const WordInputDecoration({
    required String labelText,
  }) : super(
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 25, // Set the font size for the label
            color: AppColors.text, // Set the color for the label
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.navigation, // Set the color for the focused underline
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.text, // Set the color for the enabled underline
            ),
          ),
          floatingLabelStyle: const TextStyle(
            fontSize: 20, // Set the font size for the floating label
            color: AppColors.navigationSecondary
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.error, // Set the color for the error underline
            ),
          ),
          errorStyle: const TextStyle(
            color: AppColors.error, // Set the color for the error message
          ),
        );
}



///
class SentenceFieldBox extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;


  const SentenceFieldBox({
    super.key,
    required this.controller,
    required this.labelText
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.primary,
        border: Border.all(color: AppColors.text),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: labelText,
            hintStyle: const TextStyle(
              color: AppColors.text, // Color of the labelText (hintText)
            ),
          ),
          style: const TextStyle(
            color: AppColors.text, // Color of the input text
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null, // Allows unlimited lines
        ),
      ),
    );
  }
}