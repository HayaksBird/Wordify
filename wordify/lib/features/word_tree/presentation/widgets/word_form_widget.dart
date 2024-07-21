import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/word_template/word_form_decoration.dart';

class WordFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController wordController;
  final TextEditingController translationController;
  final String? Function(String?)? wordValidation;
  final String? Function(String?)? translationValidation;


  const WordFormWidget({
    super.key,
    required this.formKey,
    required this.wordController,
    required this.translationController,
    required this.wordValidation,
    required this.translationValidation
  });


  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          WordFormField(
            controller: wordController,
            validator: wordValidation,
            labelText: 'Word'
          ),

          WordFormField(
            controller: translationController,
            validator: translationValidation,
            labelText: 'Translation'
          ),
        ],
      )
    );
  }
}