import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/core/ui_kit/folder_presentation.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/presentation/state_management/chosen_folder_provider.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/validation_bloc.dart';
import 'package:wordify/features/word_tree/presentation/widgets/choose_folder_widget.dart';

final _dictionaryBloc = DictionaryBloc();
final _validationBloc = ValidationBloc();


///
Form _form({
  required GlobalKey<FormState> formKey,
  required TextEditingController wordController,
  required TextEditingController translationController,
  required String? Function(String?)? wordValidation,
  required String? Function(String?)? translationValidation,
}) {
  return Form(
    key: formKey,
    child: Column(
      children: [
        TextFormField(
          controller: wordController,
          decoration: const InputDecoration(labelText: "Word"),
          validator: wordValidation,
        ),

        TextFormField(
          controller: translationController,
          decoration: const InputDecoration(labelText: "Translation"),
          validator: translationValidation,
        ),
      ],
    )
  );
}



///Demonstarte the word editing template
class CreateWordTemplate extends StatefulWidget {
  const CreateWordTemplate({super.key});


  @override
  State<CreateWordTemplate> createState() => _CreateWordTemplateState();
}


class _CreateWordTemplateState extends State<CreateWordTemplate> {
  Folder? storageFolder;
  final _formKey = GlobalKey<FormState>();  
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
      body: Column(
        children: [
          _form(
            formKey: _formKey,
            wordController: wordController,
            translationController: translationController,
            wordValidation: (value) => _validationBloc.word.validateWordWord(value!),
            translationValidation: (value) => _validationBloc.word.validateWordTranslation(value!)
          ),

          const Spacer(),

          _chooseFolder(),

          ButtonsInRow(
            buttons: [
              WordifyTextButton(onPressed: _return, text: 'Return'),
              WordifyElevatedButton(onPressed: _submit, text: 'Submit')
            ]
          )
        ],
      )
    );
  }


  ///
  void goBack(ValueNotifier<Folder?> valueNotifier) {
    if (valueNotifier.value != null) {
      valueNotifier.value = _dictionaryBloc.state.getParentFolder(valueNotifier.value!);
      storageFolder = valueNotifier.value;
    }
  }


  ///Show the user the list of folders where they can store the word.
  ///Uses InheritedWidget
  Widget _chooseFolder() {
    return ChosenFolderProvider(
      notifier: ValueNotifier<Folder?>(null),
      child: Builder(
        builder: (context) {
          final ValueNotifier<Folder?> valueNotifier = ChosenFolderProvider.of(context);

          return ValueListenableBuilder<Folder?>(
            valueListenable: valueNotifier,
            builder: (context, folder, child) {
              return ChooseFolder(
                goBack: () { goBack(valueNotifier); },
                folders: ValueListenableBuilder<Folder?>(
                  valueListenable: valueNotifier,
                  builder: (context, folder, child) {
                    storageFolder = folder;
                    return ChooseFolderWidget(folders: _dictionaryBloc.state.getSubfolders(folder), valueNotifier: valueNotifier);
                  },
                ),
                path: valueNotifier.value != null ? _dictionaryBloc.state.getFullPath(valueNotifier.value!) : ''
              );
            }
          );
        },
      )
    );
  }


  ///Create a new word from the updated fields.
  void _submit() {
    if (_formKey.currentState!.validate() && storageFolder != null) {
      final Word newWord = Word(
        word: wordController.text, 
        translation: translationController.text
      );

      _dictionaryBloc.content.createWord(storageFolder!, newWord);
  
      Navigator.pop(context);
    }
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
      body: Column(
        children: [
          _form(
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
              WordifyElevatedButton(onPressed: _delete, text: 'Delete'),
              WordifyElevatedButton(onPressed: _submit, text: 'Submit')
            ]
          )
        ]
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