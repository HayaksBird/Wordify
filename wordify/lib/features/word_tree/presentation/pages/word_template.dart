import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';


///Demonstarte the word editing template
class WordTemplate extends StatefulWidget {
  final Word word;
  final int? index;

  const WordTemplate({super.key, required this.word, this.index});

  @override
  State<WordTemplate> createState() => _WordTemplateState();
}


class _WordTemplateState extends State<WordTemplate> {
  final _bloc = DictionaryBloc();
  late final Word word;
  late final int? index;
  final TextEditingController wordController = TextEditingController();
  final TextEditingController translationController = TextEditingController();


  ///Set word right after the widget is initialized
  @override
  void initState() {
    super.initState();
    word = widget.word;
    index = widget.index;
  }


  ///Show word's fields, return, and submit buttons
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column (
        children: [
          Expanded (
            child: _buildFieldList()
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildReturnButton(),
                _buildSubmitbutton()
              ]
            )
          )
        ]
      )
    );
  }


  ///
  Widget _buildSubmitbutton() {
    return ElevatedButton (
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: _submit,
      child: const Text('Submit')
    );
  }


  ///
  Widget _buildReturnButton() {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: _return,
      child: const Text('Return')
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


  ///Create a new word from the updated fields.
  void _submit() {
    final Word newWord = Word(
      word: wordController.text, 
      translation: translationController.text
    );

    if (index == null) {
      _bloc.createWord(newWord);
    } else {
      _bloc.updateWord(word, newWord, index!);
    }
 
    Navigator.pop(context);
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}