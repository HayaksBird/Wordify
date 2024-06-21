import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';

class UpdateWordTemplate extends StatefulWidget {
  final Folder folder;
  final Word word;


  const UpdateWordTemplate({
    super.key,
    required this.word,
    required this.folder
  });


  @override
  State<UpdateWordTemplate> createState() => _UpdateWordTemplateState();
}


class _UpdateWordTemplateState extends State<UpdateWordTemplate> {
  late final Folder folder;
  late final Word word;
  late final int index;
  final _bloc = DictionaryBloc();
  final TextEditingController wordController = TextEditingController();
  final TextEditingController translationController = TextEditingController();



  @override
  void initState() {
    super.initState();
    folder = widget.folder;
    word = widget.word;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column (
        children: [
          Expanded (child: _buildFieldList()),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ReturnButton(onPressed: _return),
                SubmitButton(onPressed: _submit)
              ]
            )
          )
        ]
      )
    );
  }


  ///
  Widget _buildFieldList() {
    return ListView(
      children: <Widget>[
        _buildFieldTile(wordController, 'Word', word.word),
        _buildFieldTile(translationController, 'Translation', word.translation)
      ]
    );
  }


  ///
  Widget _buildFieldTile(TextEditingController controller, String fieldName, String initValue) {
    controller.text = initValue;

    return ListTile (
      title: TextFormField(
        controller: controller,
      ),
      subtitle: Text(fieldName)
    );
  }


  ///
  void _submit() {
    final Word newWord = Word(
      word: wordController.text, 
      translation: translationController.text
    );

    _bloc.updateWord(folder, word, newWord);
 
    Navigator.pop(context);
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}