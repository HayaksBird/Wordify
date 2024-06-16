import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';


///Demonstarte the word editing template
class CreateWordTemplate extends StatefulWidget {
  const CreateWordTemplate({super.key});


  @override
  State<CreateWordTemplate> createState() => _CreateWordTemplateState();
}


class _CreateWordTemplateState extends State<CreateWordTemplate> {
  Folder? storageFolder;
  late final Word word;
  final _bloc = DictionaryBloc();
  final TextEditingController wordController = TextEditingController();
  final TextEditingController translationController = TextEditingController();


  ///Set word right after the widget is initialized
  @override
  void initState() {
    super.initState();
    word = const Word();
    _bloc.loadFolders();
  }


  ///Show word's fields, return, and submit buttons
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column (
        children: [
          Expanded (child: _buildFieldList()),

          StreamBuilder<List<Folder>>(
            stream: _bloc.foldersInView,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              } else {
                return ChooseItemButton(
                  items: snapshot.data!,
                  selectedItem: storageFolder,
                  onChanged: (Folder? newFolder) {
                    setState(() {
                      storageFolder = newFolder;
                    });
                  },
                );
              }
            }
          ),

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


  ///Create a new word from the updated fields.
  void _submit() {
    final Word newWord = Word(
      word: wordController.text, 
      translation: translationController.text
    );

    _bloc.addNewWord(storageFolder!, newWord);
 
    Navigator.pop(context);
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}