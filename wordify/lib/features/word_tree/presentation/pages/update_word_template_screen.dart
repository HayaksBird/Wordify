import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/core/ui_kit/template_view/choose_word_template_widget.dart';
import 'package:wordify/core/ui_kit/template_view/template_frame.dart';
import 'package:wordify/core/ui_kit/template_view/word_form_decoration.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/presentation/state_management/chosen_folder_provider.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/validation_bloc.dart';
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
  late FolderContent newStorageFolder;
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
    newStorageFolder = expandedFolder.folder;
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
  void _goBack(ValueNotifier<FolderContent> valueNotifier) {
    valueNotifier.value = _dictionaryBloc.folderView.getParentFolder(valueNotifier.value);
    newStorageFolder = valueNotifier.value;
  }


  ///Show the user the list of folders where they can store the word.
  ///Uses InheritedWidget
  Widget _chooseFolder() {
    return ChosenFolderProvider(
      notifier: ValueNotifier<FolderContent>(newStorageFolder),
      child: Builder(
        builder: (context) {
          final ValueNotifier<FolderContent> valueNotifier = ChosenFolderProvider.of(context);

          return ValueListenableBuilder<FolderContent>(
            valueListenable: valueNotifier,
            builder: (context, folder, child) {
              newStorageFolder = folder;

              return ChooseWordTemplateWidget(
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
        word: wordController.text, 
        translation: translationController.text,
        sentence: sentenceController.text
      );

      _dictionaryBloc.content.updateWord(expandedFolder, newStorageFolder, word, newWord);
  
      Navigator.pop(context);
    }
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}