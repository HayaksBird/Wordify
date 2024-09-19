import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/presentation/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/template_view/template_frame.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/validation_bloc.dart';
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
                  validation: (value) => _validationBloc.folder.validateInsertFolderName(value!, parentFolder),
                  fieldName: 'Name'
                ),
              ],
            ),
        
            const Spacer(),
        
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
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final TempFolderContainer newFolder = TempFolderContainer(
        name: nameController.text
      );

      _dictionaryBloc.content.createFolder(parentFolder, newFolder);

      Navigator.pop(context);
    }
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}