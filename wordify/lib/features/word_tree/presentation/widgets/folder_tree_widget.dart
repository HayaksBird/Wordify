import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/components.dart';
import 'package:wordify/core/ui_kit/folder_view/folder_row_widget.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/presentation/pages/create_folder_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/pages/update_folder_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';

///Presents the folder tree in the folder view.
///Responsible for creating the and styling the tree.
///In addition, handles the add/update/delete operations within the tree.
class FolderTreetWidget extends StatelessWidget {
  final List<Folder> rootFolders;
  final _dictionaryBloc = DictionaryBloc();


  FolderTreetWidget({
    super.key,
    required this.rootFolders
  });


  @override
  Widget build(BuildContext context) {
    return _buildRootFolderList(context, rootFolders);
  }


  ///
  Widget _buildRootFolderList(BuildContext context, List<Folder> rootFolders) {
    return ListView.builder(
      itemCount: rootFolders.length + 1,
      itemBuilder: (context, index) {
        if (index == rootFolders.length) {
          return const SizedBox(height: 100); //Add extra space at the end of the list
        } else {
          return _buildFolderTile(context, rootFolders[index], 0);
        }
      }
    );
  }


  Widget _buildInnerFolderList(BuildContext context, List<Folder> folders, int layer) {
    return Column(
      children: folders.map((folder) => _buildFolderTile(context, folder, layer)).toList(),
    );
  }



  ///
  Widget _buildFolderTile(BuildContext context, Folder folder, int layer) {
    return Column(
      children: [
        GestureDetector(
          onSecondaryTapDown: (details) { _showOverlay(context, details, folder); },
          child: FolderRowWidget(
            isExpanded: _dictionaryBloc.folderView.isToExpand(folder),
            toggleFolder: () { _dictionaryBloc.folderView.toggleFolder(folder); },
            layer: layer,
            isFirstFolder: folder == rootFolders[0],
            listTile: GestureDetector(
              onDoubleTap: () { _dictionaryBloc.wordView.accessFolder(folder); },
              child: FolderTileWidget(
                name: folder.name,
                isActivated: _dictionaryBloc.wordView.isActivated(folder)
              ),
            ),
          ),
        ),

        if (_dictionaryBloc.folderView.isToExpand(folder))
          _buildInnerFolderList(context, _dictionaryBloc.folderView.getSubfolders(folder), layer + 1)
      ]
    );
  }


  ///
  void _showOverlay(BuildContext context, TapDownDetails details, Folder folder) {
    WordifyOverlayEntry.showOverlay(
      inputs: [
        DoAction(
          title: 'Create',
          action: () { _createFolder(context, folder); }
        ),

        DoAction(
          title: 'Update',
          action: () { _updateFolder(context, folder); }
        ),

        DoAction(
          title: 'Delete',
          action: () { _dictionaryBloc.content.deleteFolder(folder); }
        )
      ], 
      context: context,
      tapPosition: details.globalPosition
    );
  }


  ///
  void _updateFolder(BuildContext context,Folder folder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UpdateFolderTemplate(
          folder: folder
        )
      ),
    );
  }


  ///
  void _createFolder(BuildContext context, Folder parentFolder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateFolderTemplate(
          parentFolder: parentFolder
        )
      ),
    );
  }
}