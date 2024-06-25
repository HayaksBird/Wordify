import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';


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
  final _bloc = DictionaryBloc();
  final TextEditingController nameController = TextEditingController();


  @override
  void initState() {
    super.initState();
    folder = widget.folder;
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
        _buildFieldTile(nameController, 'Name', folder.name),
      ]
    );
  }


  ///
  Widget _buildFieldTile(TextEditingController controller, String fieldName, String initValue) {
    controller.text = initValue;

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

    _bloc.updateFolder(folder, newFolder);
 
    Navigator.pop(context);
  }


  ///Return back without editing the word.
  void _return() {
    Navigator.pop(context);
  }
}