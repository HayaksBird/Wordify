import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/folder_validation_bloc.dart';

///
class UpdateFolderTemplate extends StatefulWidget {
  final Folder folder;


  const UpdateFolderTemplate({
    super.key,
    required this.folder
  });


  @override
  State<UpdateFolderTemplate> createState() => _UpdateFolderTemplateState();
}


class _UpdateFolderTemplateState extends State<UpdateFolderTemplate> {
  late final Folder folder;
  final _dictionaryBloc = DictionaryBloc();
  final _folderValidationBloc = FolderValidationBloc();
  final _formKey = GlobalKey<FormState>();
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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
              validator: (value) => _folderValidationBloc.validateFolderName(value!, folder.name),
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
      final Folder newFolder = Folder(
        name: nameController.text
      );

      _dictionaryBloc.updateFolder(folder, newFolder);
  
      Navigator.pop(context);
    }
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}