import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/folder_validation_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/word_validation_bloc.dart';


///Demonstarte the word editing template
class CreateWordTemplate extends StatefulWidget {
  const CreateWordTemplate({super.key});


  @override
  State<CreateWordTemplate> createState() => _CreateWordTemplateState();
}


class _CreateWordTemplateState extends State<CreateWordTemplate> {
  Folder? storageFolder;
  late final Word word;
  final _formKey = GlobalKey<FormState>();
  final _dictionaryBloc = DictionaryBloc();
  final _wordValidationBloc = WordValidationBloc();
  final _folderValidationBloc = FolderValidationBloc(); 
  final TextEditingController wordController = TextEditingController();
  final TextEditingController translationController = TextEditingController();


  ///Set word right after the widget is initialized
  @override
  void initState() {
    super.initState();
    word = const Word();
    _dictionaryBloc.loadFolders();
  }


  ///Show word's fields, return, and submit buttons
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column (
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
        
            StreamBuilder<List<NTreeNode<Folder>>>(
              stream: _dictionaryBloc.foldersInView,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                } else {
                  /*
                  StatefulBuilder ensures that only the ChooseItemButton widget gets
                  updated when the button value is changed.
                  */
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return ChooseItemButton(
                        validator: (value) => _folderValidationBloc.validateChooseFolder(value),
                        items: /*snapshot.data!*/ [],
                        selectedItem: storageFolder,
                        onChanged: (Folder? newFolder) {
                          setState(() {
                            storageFolder = newFolder;
                          });
                        },
                      );
                    }
                  );
                }
              }
            ),
        
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


  ///Create a new word from the updated fields.
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final Word newWord = Word(
        word: wordController.text, 
        translation: translationController.text
      );

      _dictionaryBloc.addNewWord(storageFolder!, newWord);
  
      Navigator.pop(context);
    }
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}