import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/core/presentation/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/template_view/choose_folder_template_widget.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/template_view/template_frame.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/template_view/word_form_decoration.dart';
import 'package:wordify/features/word_tree/presentation/state_management/providers/chosen_folder_provider.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/validation_bloc/validation_bloc.dart';
import 'package:wordify/features/word_tree/presentation/widgets/choose_folder_widget.dart';
import 'package:wordify/features/word_tree/presentation/widgets/form_widget.dart';

///
class UpdateWordTemplate extends StatefulWidget {
  final FolderWords expandedFolder;
  final WordContent word;


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
  late FolderContent? newStorageFolder;
  late final WordContent word;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController wordController;
  late final TextEditingController translationController;
  late final TextEditingController sentenceController;
  final _dictionaryBloc = DictionaryBloc();
  final _validationBloc = ValidationBloc();


  @override
  void initState() {
    super.initState();
    expandedFolder = widget.expandedFolder;
    newStorageFolder = expandedFolder.folder != _dictionaryBloc.folderView.bufferFolder ? expandedFolder.folder : null;
    word = widget.word;
    wordController = TextEditingController(text: word.word);
    translationController = TextEditingController(text: word.translation);
    sentenceController = TextEditingController(text: word.sentence);
  }


  @override
  void dispose() {
    wordController.dispose();
    translationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TemplateFrame(
        child: Column(
          children: [
            FormWidget(
              formKey: _formKey,
              fields: [
                FormFieldInput(
                  controller: wordController,
                  validation: (value) => _validationBloc.word.validateWordWord(value!),
                  fieldName: 'Word'
                ),
                FormFieldInput(
                  controller: translationController,
                  validation: (value) => _validationBloc.word.validateWordTranslation(value!),
                  fieldName: 'Translation'
                )
              ]
            ),

            const Spacer(),

            SentenceFieldBox(
              controller: sentenceController,
              labelText: 'Example...',
            ),
        
            const Spacer(),

            _chooseFolder(),
        
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
  void _goBack(ValueNotifier<FolderContent?> valueNotifier) {
    if (valueNotifier.value != null) {
      valueNotifier.value = _dictionaryBloc.folderView.getParentFolder(valueNotifier.value!);
      newStorageFolder = valueNotifier.value;
    }
  }


  ///Show the user the list of folders where they can store the word.
  ///Uses InheritedWidget
  Widget _chooseFolder() {
    return ChosenFolderProvider(
      notifier: ValueNotifier<FolderContent?>(newStorageFolder),
      child: Builder(
        builder: (context) {
          final ValueNotifier<FolderContent?> valueNotifier = ChosenFolderProvider.of(context);

          return ValueListenableBuilder<FolderContent?>(
            valueListenable: valueNotifier,
            builder: (context, folder, child) {
              newStorageFolder = folder;

              return ChooseFolderTemplateWidget(
                goBack: () { _goBack(valueNotifier); },
                folders: ChooseFolderWidget(folders: _dictionaryBloc.folderView.getSubfolders(folder), valueNotifier: valueNotifier),
                path: _dictionaryBloc.folderView.getFullPath(valueNotifier.value)
              );
            }
          );
        },
      )
    );
  }


  ///
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final TempWordContainer newWord = TempWordContainer(
        word: wordController.text.trim(), 
        translation: translationController.text.trim(),
        sentence: sentenceController.text.trim()
      );

      _dictionaryBloc.wordContent.updateWord(expandedFolder, newStorageFolder, word, newWord);
  
      Navigator.pop(context);
    }
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}