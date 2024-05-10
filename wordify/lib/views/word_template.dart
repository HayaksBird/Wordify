import 'package:flutter/material.dart';
import 'package:wordify/models/data_layer.dart';


///Demonstarte the word editing template
class WordTemplate extends StatefulWidget {
  final Word word;

  const WordTemplate({super.key, required this.word});

  @override
  State<WordTemplate> createState() => _WordTemplateState();
}


class _WordTemplateState extends State<WordTemplate> {
  late final Word word;
  final TextEditingController wordController = TextEditingController();
  final TextEditingController translationController = TextEditingController();


  ///Set word right after the widget is initialized
  @override
  void initState() {
    super.initState();
    word = widget.word;
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


  ///Create a new word from the updated fields
  void _submit() {
    final Word newWord = Word(
      word: wordController.text, 
      translation: translationController.text
    );

    Navigator.pop(context, newWord);
  }


  ///
  void _return() {
    Navigator.pop(context);
  }
}