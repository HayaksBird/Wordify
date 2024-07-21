import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/core/ui_kit/word_template/word_template_frame.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/validation_bloc.dart';
import 'package:wordify/features/word_tree/presentation/widgets/word_form_widget.dart';

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
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController wordController;
  late final TextEditingController translationController;
  final _dictionaryBloc = DictionaryBloc();
  final _validationBloc = ValidationBloc();


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
      body: WordTemplateFrame(
        child: Column(
          children: [
            WordFormWidget(
              formKey: _formKey,
              wordController: wordController,
              translationController: translationController,
              wordValidation: (value) => _validationBloc.word.validateWordWord(value!),
              translationValidation: (value) => _validationBloc.word.validateWordTranslation(value!)
            ),
        
            const Spacer(),
        
            ButtonsInRow(
              buttons: [
                WordifyTextButton(onPressed: _return, text: 'Return'),
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

      _dictionaryBloc.content.updateWord(expandedFolder, word, newWord);
  
      Navigator.pop(context);
    }
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}