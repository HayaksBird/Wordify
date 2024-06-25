import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';


///
class CreateFolderTemplate extends StatefulWidget {
  const CreateFolderTemplate({
    super.key,
  });


  @override
  State<CreateFolderTemplate> createState() => _CreateFolderTemplateState();
}


class _CreateFolderTemplateState extends State<CreateFolderTemplate> {
  final _bloc = DictionaryBloc();
  final TextEditingController nameController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _buildFieldList()),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WordifyTextButton(onPressed: _return, text: 'Return'),
                WordifyElevatedButton(onPressed: _submit, text: 'Submit')
              ]
            )
          )
        ]
      )
    );
  }


  ///
  Widget _buildFieldList() {
    return ListView(
      children: <Widget>[
        _buildFieldTile(nameController, 'Name'),
      ]
    );
  }


  ///
  Widget _buildFieldTile(TextEditingController controller, String fieldName) {
    return ListTile (
      title: TextFormField(
        controller: controller,
      ),
      subtitle: Text(fieldName)
    );
  }


  ///
  void _submit() {
    final Folder newFolder = Folder(
      name: nameController.text
    );

    _bloc.createFolder(newFolder);
 
    Navigator.pop(context);
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}