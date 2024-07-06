import 'package:flutter/material.dart';
import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///
class ChooseFolderWidget extends StatelessWidget {
  final List<NTreeNode<Folder>> folders;
  final ValueNotifier<NTreeNode<Folder>?> valueNotifier;


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
  Widget _buildFolderTile(NTreeNode<Folder> folder) {
    return InkWell(
      onTap: () {
        valueNotifier.value = folder;
      },
      child: ListTile(
        title: Text(folder.item.name)
      )
    );
  }
}