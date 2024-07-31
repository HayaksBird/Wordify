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


///Demonstarte the word editing template
class CreateWordTemplate extends StatefulWidget {
  final Folder storageFolder;


  const CreateWordTemplate({
    super.key,
    required this.storageFolder
  });


  @override
  State<CreateWordTemplate> createState() => _CreateWordTemplateState();
}


class _CreateWordTemplateState extends State<CreateWordTemplate> {
  late Folder storageFolder;
  final _formKey = GlobalKey<FormState>();  
  final TextEditingController wordController = TextEditingController();
  final TextEditingController translationController = TextEditingController();
  final TextEditingController sentenceController = TextEditingController();
  final _dictionaryBloc = DictionaryBloc();
  final _validationBloc = ValidationBloc();


  ///Set word right after the widget is initialized
  @override
  void initState() {
    super.initState();
    storageFolder = widget.storageFolder;
  }


  @override
  void dispose() {
    wordController.dispose();
    translationController.dispose();
    sentenceController.dispose();
    super.dispose();
  }


  ///Show word's fields, return, and submit buttons
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
              ],
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
          ],
        ),
      )
    );
  }


  ///
  void _goBack(ValueNotifier<Folder> valueNotifier) {
    valueNotifier.value = _dictionaryBloc.folderView.getParentFolder(valueNotifier.value);
    storageFolder = valueNotifier.value;
  }


  ///Show the user the list of folders where they can store the word.
  ///Uses InheritedWidget
  Widget _chooseFolder() {
    return ChosenFolderProvider(
      notifier: ValueNotifier<Folder>(storageFolder),
      child: Builder(
        builder: (context) {
          final ValueNotifier<Folder> valueNotifier = ChosenFolderProvider.of(context);

          return ValueListenableBuilder<Folder>(
            valueListenable: valueNotifier,
            builder: (context, folder, child) {
              storageFolder = folder;

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


  ///Create a new word from the updated fields.
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final Word newWord = Word(
        word: wordController.text, 
        translation: translationController.text,
        sentence: sentenceController.text
      );

      _dictionaryBloc.content.createWord(storageFolder, newWord);
  
      Navigator.pop(context);
    }
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}