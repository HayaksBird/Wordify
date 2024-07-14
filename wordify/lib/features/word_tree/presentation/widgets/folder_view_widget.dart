import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/components.dart';
import 'package:wordify/core/ui_kit/folder_presentation.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/pages/folder_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';


///Present the list of type FolderContentWidget,
///showing all words in an active folder list.
class FolderViewWidget extends StatefulWidget {
  const FolderViewWidget({super.key});

  @override
  State<FolderViewWidget> createState() => _FolderViewWidgetState();
}


class _FolderViewWidgetState extends State<FolderViewWidget> {
  final _dictionaryBloc = DictionaryBloc();


  @override
  void initState() {
    super.initState();
    _dictionaryBloc.state.loadFolders();
  }


  @override
  void dispose() {
    super.dispose();
    _dictionaryBloc.state.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FolderList(
      child: GestureDetector(
        onSecondaryTap: () => _createFolder(),
        child: Stack(
          children: [
            StreamBuilder<List<Folder>>(
              stream: _dictionaryBloc.state.foldersInView,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return _buildRootFolderList(snapshot.data!);
                }
              },
            )
          ],
        )
      )
    );
  }


  ///
  Widget _buildRootFolderList(List<Folder> rootFolders) {
    return ListView.builder(
      itemCount: rootFolders.length + 1,
      itemBuilder: (context, index) {
        if (index == rootFolders.length) {
          return const SizedBox(height: 100); //Add extra space at the end of the list
        } else {
          return _buildFolderTile(rootFolders[index]);
        }
      }
    );
  }


  ///
  Widget _buildInnerFolderList(List<Folder> folders) {
    return ListView.builder(
      itemCount: folders.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildFolderTile(folders[index]);
      }
    );
  }


  ///
  Widget _buildFolderTile(Folder folder) {
    return Column(
      children: [
        FolderTile(
          isExpanded: _dictionaryBloc.state.isToExpand(folder),
          toggleFolder: () { _dictionaryBloc.state.toggleFolder(folder); },
          expandFolder: () { _dictionaryBloc.state.accessFolder(folder); },
          listTile: ListTile(
            title: Text(
              folder.name,
              style: TextStyle(
                color: _dictionaryBloc.state.isActivated(folder) ? const Color.fromARGB(255, 114, 114, 114) : Colors.black
              )
            ),
          ),
          folderOperations: (details) {
            WordifyOverlayEntry.showOverlay(
              [
                DoAction(
                  title: 'Create',
                  action: () { _createFolder(folder); }
                ),
        
                DoAction(
                  title: 'Update',
                  action: () { _updateFolder(folder); }
                ),
        
                DoAction(
                  title: 'Delete',
                  action: () { _dictionaryBloc.content.deleteFolder(folder); }
                )
              ], 
              context,
              details.globalPosition
            );
          },
        ),

        if (_dictionaryBloc.state.isToExpand(folder))
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: _buildInnerFolderList(_dictionaryBloc.state.getSubfolders(folder))
          )
      ]
    );
  }
  

  void _updateFolder(Folder folder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UpdateFolderTemplate(
          folder: folder
        )
      ),
    );
  }


  void _createFolder([Folder? parentFolder]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateFolderTemplate(
          parentFolder: parentFolder
        )
      ),
    );
  }
}