import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/presentation/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/presentation/state_management/providers/parent_folder_provider.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/template_view/choose_folder_template_widget.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/template_view/template_frame.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/validation_bloc/validation_bloc.dart';
import 'package:wordify/features/word_tree/presentation/widgets/choose_folder_widget.dart';
import 'package:wordify/features/word_tree/presentation/widgets/form_widget.dart';

class CreateFolderTemplate extends StatefulWidget {
  final FolderContent? parentFolder;


  const CreateFolderTemplate({
    super.key,
    this.parentFolder
  });


  @override
  State<CreateFolderTemplate> createState() => _CreateFolderTemplateState();
}

class _CreateFolderTemplateState extends State<CreateFolderTemplate> {
  late final FolderContent? parentFolder;
  late FolderContent? newParentFolder;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final _dictionaryBloc = DictionaryBloc();
  final _validationBloc = ValidationBloc();


  @override
  void initState() {
    super.initState();
    parentFolder = widget.parentFolder;
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
                  controller: nameController,
                  validation: (value) => _validationBloc.folder.validateInsertFolderName(value!, newParentFolder),
                  fieldName: 'Name'
                ),
              ],
            ),
        
            const Spacer(),

            _chooseParentFolder(),
        
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
      newParentFolder = valueNotifier.value;
    }
  }


  ///
  Widget _chooseParentFolder() {
    return ParentFolderProvider(
      notifier: ValueNotifier<FolderContent?>(parentFolder),
      child: Builder(
        builder: (context) {
          final ValueNotifier<FolderContent?> valueNotifier = ParentFolderProvider.of(context);

          return ValueListenableBuilder<FolderContent?>(
            valueListenable: valueNotifier,
            builder: (context, chosenParent, child) {
              newParentFolder = chosenParent;

              return ChooseFolderTemplateWidget(
                goBack: () { _goBack(valueNotifier); },
                folders: ChooseFolderWidget(
                  folders: _dictionaryBloc.folderView.getSubfolders(newParentFolder),
                  valueNotifier: valueNotifier
                ),
                path: _dictionaryBloc.folderView.getFullPath(valueNotifier.value),
                pathMessage: 'Parent folder'
              );
            }
          );
        }
      )
    );
  }


  ///
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final TempFolderContainer newFolder = TempFolderContainer(
        name: nameController.text.trim()
      );

      _dictionaryBloc.folderContent.createFolder(newParentFolder, newFolder);

      Navigator.pop(context);
    }
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}