import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/validation_bloc.dart';


final _dictionaryBloc = DictionaryBloc();
final _validationBloc = ValidationBloc();


///
Form _form({
  required GlobalKey<FormState> formKey,
  required TextEditingController nameController,
  required String? Function(String?)? validation
}) {
  return Form(
    key: formKey,
    child: TextFormField(
      controller: nameController,
      decoration: const InputDecoration(labelText: "Name"),
      validator: validation,
    ),
  );
}


///
ButtonsInRow _buttonsInRow({
  required void Function() returnBack,
  required void Function() submit
}) {
  return  ButtonsInRow(
    buttons: [
      WordifyTextButton(onPressed: returnBack, text: 'Return'),
      WordifyElevatedButton(onPressed: submit, text: 'Submit')
    ]
  );
}



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
      body: Column(
        children: [
          _form(
            formKey: _formKey,
            nameController: nameController,
            validation: (value) => _validationBloc.folder.validateInsertFolderName(value!, parentFolder)
          ),
      
          const Spacer(),
      
          _buttonsInRow(
            returnBack: _return,
            submit: _submit
          )
        ]
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
      body: Column(
        children: [
          _form(
            formKey: _formKey,
            nameController: nameController,
            validation: (value) => _validationBloc.folder.validateUpdateFolderName(value!, folder, folder.name)
          ),

          const Spacer(),
      
          _buttonsInRow(
            returnBack: _return,
            submit: _submit
          )
        ]
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