import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/folder_validation_bloc.dart';

///
class CreateFolderTemplate extends StatefulWidget {
  const CreateFolderTemplate({
    super.key,
  });


  @override
  State<CreateFolderTemplate> createState() => _CreateFolderTemplateState();
}


class _CreateFolderTemplateState extends State<CreateFolderTemplate> {
  final _dictionaryBloc = DictionaryBloc();
  final _folderValidationBloc = FolderValidationBloc();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();


  @override
  void initState() {
    super.initState();
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
              validator: (value) => _folderValidationBloc.validateFolderName(value!),
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

      _dictionaryBloc.createFolder(newFolder);

      Navigator.pop(context);
    }
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}