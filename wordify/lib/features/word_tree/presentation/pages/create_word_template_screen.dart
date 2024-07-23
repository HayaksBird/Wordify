import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/core/ui_kit/template_view/choose_word_template_widget.dart';
import 'package:wordify/core/ui_kit/template_view/template_frame.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/presentation/state_management/chosen_folder_provider.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/validation_bloc.dart';
import 'package:wordify/features/word_tree/presentation/widgets/choose_folder_widget.dart';
import 'package:wordify/features/word_tree/presentation/widgets/form_widget.dart';


///Demonstarte the word editing template
class CreateWordTemplate extends StatefulWidget {
  final Folder? storageFolder;


  const CreateWordTemplate({super.key, this.storageFolder});


  @override
  State<CreateWordTemplate> createState() => _CreateWordTemplateState();
}


class _CreateWordTemplateState extends State<CreateWordTemplate> {
  Folder? storageFolder;
  final _formKey = GlobalKey<FormState>();  
  final TextEditingController wordController = TextEditingController();
  final TextEditingController translationController = TextEditingController();
  final _dictionaryBloc = DictionaryBloc();
  final _validationBloc = ValidationBloc();


  ///Set word right after the widget is initialized
  @override
  void initState() {
    super.initState();
    storageFolder = widget.storageFolder;
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
  void goBack(ValueNotifier<Folder?> valueNotifier) {
    if (valueNotifier.value != null) {
      valueNotifier.value = _dictionaryBloc.folderView.getParentFolder(valueNotifier.value!);
      storageFolder = valueNotifier.value;
    }
  }


  ///Show the user the list of folders where they can store the word.
  ///Uses InheritedWidget
  Widget _chooseFolder() {
    return ChosenFolderProvider(
      notifier: ValueNotifier<Folder?>(storageFolder),
      child: Builder(
        builder: (context) {
          final ValueNotifier<Folder?> valueNotifier = ChosenFolderProvider.of(context);

          return ValueListenableBuilder<Folder?>(
            valueListenable: valueNotifier,
            builder: (context, folder, child) {
              return ChooseWordTemplateWidget(
                goBack: () { goBack(valueNotifier); },
                folders: ValueListenableBuilder<Folder?>(
                  valueListenable: valueNotifier,
                  builder: (context, folder, child) {
                    storageFolder = folder;
                    return ChooseFolderWidget(folders: _dictionaryBloc.folderView.getSubfolders(folder), valueNotifier: valueNotifier);
                  },
                ),
                path: valueNotifier.value != null ? _dictionaryBloc.folderView.getFullPath(valueNotifier.value!) : ''
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