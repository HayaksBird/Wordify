import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/word_validation_bloc.dart';

///
class UpdateWordTemplate extends StatefulWidget {
  final FolderWords expandedFolder;
  final Word word;


  const UpdateWordTemplate({
    super.key,
    required this.word,
    required this.expandedFolder
  });


  @override
  State<UpdateWordTemplate> createState() => _UpdateWordTemplateState();
}


class _UpdateWordTemplateState extends State<UpdateWordTemplate> {
  late final FolderWords expandedFolder;
  late final Word word;
  final _wordValidationBloc = WordValidationBloc();
  final _dictionaryBloc = DictionaryBloc();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController wordController;
  late final TextEditingController translationController;



  @override
  void initState() {
    super.initState();
    expandedFolder = widget.expandedFolder;
    word = widget.word;
    wordController = TextEditingController(text: word.word);
    translationController = TextEditingController(text: word.translation);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: wordController,
              decoration: const InputDecoration(labelText: "Word"),
              validator: (value) => _wordValidationBloc.validateWordWord(value!),
            ),

            TextFormField(
              controller: translationController,
              decoration: const InputDecoration(labelText: "Translation"),
              validator: (value) => _wordValidationBloc.validateWordTranslation(value!),
            ),

            const Spacer(),

            ButtonsInRow(
              buttons: [
                WordifyTextButton(onPressed: _return, text: 'Return'),
                WordifyElevatedButton(onPressed: _delete, text: 'Delete'),
                WordifyElevatedButton(onPressed: _submit, text: 'Submit')
              ]
            )
          ]
        ),
      )
    );
  }


  ///
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final Word newWord = Word(
        word: wordController.text, 
        translation: translationController.text
      );

      _dictionaryBloc.updateWord(expandedFolder, word, newWord);
  
      Navigator.pop(context);
    }
  }


  ///
  void _delete() {
    _dictionaryBloc.deleteWord(expandedFolder, word);

    Navigator.pop(context);
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}