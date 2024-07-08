import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///Shows the list of folders where the user can save the newly typed
///word.
class ChooseFolderWidget extends StatelessWidget {
  final List<Folder> folders;
  final ValueNotifier<Folder?> valueNotifier;


  const ChooseFolderWidget({
    super.key,
    required this.folders,
    required this.valueNotifier
  });


  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 200.0,
      ),
      child: _buildFolderList()
    );
  }


  ///
  Widget _buildFolderList() {
    return ListView.builder(
      itemCount: folders.length,
      itemBuilder: (context, index) {
        return _buildFolderTile(folders[index]);
      }
    );
  }


  ///
  Widget _buildFolderTile(Folder folder) {
    return InkWell(
      onTap: () {
        valueNotifier.value = folder;
      },
      child: ListTile(
        title: Text(folder.name)
      )
    );
  }
}