import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/template_view/word_form_decoration.dart';

///
class FormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<FormFieldInput> fields;


  const FormWidget({
    super.key,
    required this.formKey,
    required this.fields
  });


  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: fields.map((field) {
          return WordFormField(
            controller: field.controller,
            validator: field.validation,
            labelText: field.fieldName
          );
        }).toList()
      )
    );
  }
}



///
class FormFieldInput {
  final TextEditingController controller;
  final String? Function(String?)? validation;
  final String fieldName;


  const FormFieldInput({
    required this.controller,
    required this.validation,
    required this.fieldName
  });
}