import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/template_view/choose_folder_tile_widget.dart';

///Shows the list of folders where the user can save the newly typed
///word.
class ChooseFolderWidget extends StatelessWidget {
  final List<FolderContent> folders;
  final ValueNotifier<FolderContent> valueNotifier;


  const ChooseFolderWidget({
    super.key,
    required this.folders,
    required this.valueNotifier
  });


  @override
  Widget build(BuildContext context) {
    return _buildFolderList();
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
  Widget _buildFolderTile(FolderContent folder) {
    return InkWell(
      onTap: () {
        valueNotifier.value = folder;
      },
      child: ChooseFolderTileWidget(
        name: folder.name
      )
    );
  }
}