import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/validation_bloc.dart';

///
class CreateFolderTemplate extends StatefulWidget {
  final Folder? parentFolder;


  const CreateFolderTemplate({
    super.key,
    this.parentFolder
  });


  @override
  State<CreateFolderTemplate> createState() => _CreateFolderTemplateState();
}


class _CreateFolderTemplateState extends State<CreateFolderTemplate> {
  late final Folder? parentFolder;
  final _dictionaryBloc = DictionaryBloc();
  final _validationBloc = ValidationBloc();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();


  @override
  void initState() {
    super.initState();
    parentFolder = widget.parentFolder;
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
              validator: (value) => _validationBloc.folder.validateInsertFolderName(value!, parentFolder),
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

      _dictionaryBloc.content.createFolder(parentFolder, newFolder);

      Navigator.pop(context);
    }
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}



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
  final _validationBloc = ValidationBloc();
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
              validator: (value) => _validationBloc.folder.validateUpdateFolderName(value!, folder, folder.name),
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

      _dictionaryBloc.content.updateFolder(folder, newFolder);
  
      Navigator.pop(context);
    }
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}