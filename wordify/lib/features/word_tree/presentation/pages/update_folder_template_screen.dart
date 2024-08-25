import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/template_view/template_frame.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/validation_bloc.dart';
import 'package:wordify/features/word_tree/presentation/widgets/form_widget.dart';

///
class UpdateFolderTemplate extends StatefulWidget {
  final FolderContent folder;


  const UpdateFolderTemplate({
    super.key,
    required this.folder
  });


  @override
  State<UpdateFolderTemplate> createState() => _UpdateFolderTemplateState();
}

class _UpdateFolderTemplateState extends State<UpdateFolderTemplate> {
  late final FolderContent folder;
  final _formKey = GlobalKey<FormState>();
  final _dictionaryBloc = DictionaryBloc();
  final _validationBloc = ValidationBloc();
  late final TextEditingController nameController;


  @override
  void initState() {
    super.initState();
    folder = widget.folder;
    nameController = TextEditingController(text: folder.name);
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
                  validation: (value) => _validationBloc.folder.validateUpdateFolderName(value!, folder, folder.name),
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

      _dictionaryBloc.content.updateFolder(folder, newFolder);
  
      Navigator.pop(context);
    }
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}