import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/folder_view/folder_actions_overlay.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/folder_view/folder_row_widget.dart';
import 'package:wordify/features/word_tree/presentation/pages/create_folder_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/pages/update_folder_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/dictionary_bloc.dart';

///Presents the folder tree in the folder view.
///Responsible for creating the and styling the tree.
///In addition, handles the add/update/delete operations within the tree.
class FolderTreetWidget extends StatelessWidget {
  final List<FolderContent> rootFolders;
  final _dictionaryBloc = DictionaryBloc();
  final ValueNotifier<bool> folderViewExpandNotifier;


  FolderTreetWidget({
    super.key,
    required this.rootFolders,
    required this.folderViewExpandNotifier
  });


  @override
  Widget build(BuildContext context) {
    return _buildRootFolderList(context, rootFolders);
  }


  ///
  Widget _buildRootFolderList(BuildContext context, List<FolderContent> rootFolders) {
    return ListView.builder(
      itemCount: rootFolders.length + 1,
      itemBuilder: (context, index) {
        if (index == rootFolders.length) {
          return const SizedBox(height: 100); //Add extra space at the end of the list
        } else {
          //Nullify the effect of the parent GestureDetector
          return MouseRegion(
            onEnter: (enter) { _dictionaryBloc.folderView.allowBufferView(false); },
            onExit: (exit) { _dictionaryBloc.folderView.allowBufferView(true); },
            child: _buildFolderTile(context, rootFolders[index], 0)
          );
        }
      }
    );
  }


  ///
  Widget _buildInnerFolderList(BuildContext context, List<FolderContent> folders, int layer) {
    return Column(
      children: folders.map((folder) => _buildFolderTile(context, folder, layer)).toList(),
    );
  }


  ///
  Widget _buildFolderTile(BuildContext context, FolderContent folder, int layer) {
    return Column(
      children: [
        GestureDetector(
          onSecondaryTapDown: (details) {
            _dictionaryBloc.folderView.setSelectedFolder(folder);
            _showOverlay(context, details, folder); 
          },
          child: FolderRowWidget(
            isExpanded: _dictionaryBloc.folderView.isToExpand(folder) && _dictionaryBloc.folderView.canShowSubfolders(folderViewExpandNotifier.value, layer),
            toggleFolder: () {
              _dictionaryBloc.folderView.toggleFolder(folderViewExpandNotifier.value, layer, folder);
              if (_dictionaryBloc.folderView.triggerExpand(folderViewExpandNotifier.value, layer, folder)) { folderViewExpandNotifier.value = true; }
            },
            layer: layer,
            isFirstFolder: folder == rootFolders[0],
            isSelected: folder == _dictionaryBloc.folderView.getSelectedFolder,
            listTile: GestureDetector(
              onDoubleTap: () { _dictionaryBloc.wordView.accessFolder(folder); },
              child: FolderTileWidget(
                name: folder.name,
                isActivated: _dictionaryBloc.wordView.isActivated(folder)
              ),
            ),
          ),
        ),

        if (_dictionaryBloc.folderView.isToExpand(folder) && _dictionaryBloc.folderView.canShowSubfolders(folderViewExpandNotifier.value, layer))
          _buildInnerFolderList(context, _dictionaryBloc.folderView.getSubfolders(folder), layer + 1)
      ]
    );
  }


  ///
  void _showOverlay(BuildContext context, TapDownDetails details, FolderContent folder) {
    FolderActionsOverlay.showOverlay(
      create: () { _createFolder(context, folder); },
      update: () { _updateFolder(context, folder); },
      delete: () { _dictionaryBloc.folderContent.deleteFolder(folder); },
      onOverlayClosed: _overlayClosed,
      position: details.globalPosition,
      context: context
    );
  }


  ///
  void _updateFolder(BuildContext context, FolderContent folder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UpdateFolderTemplate(
          folder: folder
        )
      ),
    );
  }


  ///
  void _createFolder(BuildContext context, FolderContent parentFolder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateFolderTemplate(
          parentFolder: parentFolder
        )
      ),
    );
  }


  ///Unselect the word
  void _overlayClosed() {
    _dictionaryBloc.folderView.setSelectedFolder(null);
  }
}