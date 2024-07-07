import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/core/ui_kit/folder_presentation.dart';
import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/presentation/state_management/chosen_folder_provider.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/validation_bloc.dart';
import 'package:wordify/features/word_tree/presentation/widgets/choose_folder_widget.dart';


///Demonstarte the word editing template
class CreateWordTemplate extends StatefulWidget {
  const CreateWordTemplate({super.key});


  @override
  State<CreateWordTemplate> createState() => _CreateWordTemplateState();
}


class _CreateWordTemplateState extends State<CreateWordTemplate> {
  Folder? storageFolder;
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
    _dictionaryBloc.state.loadFolders();
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

            ChosenFolderProvider(
              notifier: ValueNotifier<Folder?>(null),
              child: FutureBuilder<NTree<Folder>>(
                future: _dictionaryBloc.state.folderTree,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    final ValueNotifier<Folder?> valueNotifier = ChosenFolderProvider.of(context);

                    return ChooseFolder(
                      goBack: () { goBack(valueNotifier, snapshot.data!); },
                      folders: ValueListenableBuilder<Folder?>(
                        valueListenable: valueNotifier,
                        builder: (context, folder, child) {
                          if (folder == null) {
                            return ChooseFolderWidget(folders: snapshot.data!.getRootFolders, valueNotifier: valueNotifier);
                          } else {
                            storageFolder = folder;
                            return ChooseFolderWidget(folders: snapshot.data!.getChildren(folder), valueNotifier: valueNotifier);
                          }
                        },
                      ),
                      path: valueNotifier.value != null ? _dictionaryBloc.state.getFullPath(valueNotifier.value!) : ''
                    );
                  }
                }
              ),
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


  ///
  void goBack(ValueNotifier<Folder?> valueNotifier, NTree<Folder> folderTree) {
    if (valueNotifier.value != null) {
      valueNotifier.value = folderTree.getParent(valueNotifier.value!);
      storageFolder = valueNotifier.value;
    }
  }


  ///Create a new word from the updated fields.
  void _submit() {
    //if (_formKey.currentState!.validate()) {
      final Word newWord = Word(
        word: wordController.text, 
        translation: translationController.text
      );

      _dictionaryBloc.content.createWord(storageFolder!, newWord);
  
      Navigator.pop(context);
    //}
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}



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
    //if (_formKey.currentState!.validate()) {
      final Word newWord = Word(
        word: wordController.text, 
        translation: translationController.text
      );

      _dictionaryBloc.content.updateWord(expandedFolder, word, newWord);
  
      Navigator.pop(context);
    //}
  }


  ///
  void _delete() {
    _dictionaryBloc.content.deleteWord(expandedFolder, word);

    Navigator.pop(context);
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}