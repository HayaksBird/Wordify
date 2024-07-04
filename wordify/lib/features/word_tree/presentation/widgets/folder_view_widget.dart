import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/components.dart';
import 'package:wordify/core/ui_kit/folder_presentation.dart';
import 'package:wordify/core/util/n_tree.dart';
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
  final _dictionaryStateBloc = DictionaryStateBloc();
  final _dictionaryContentBloc = DictionaryContentBloc();


  @override
  void initState() {
    super.initState();
    _dictionaryStateBloc.loadFolders();
  }


  @override
  void dispose() {
    super.dispose();
    _dictionaryStateBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FolderList(
      child: GestureDetector(
        onSecondaryTap: () => _createFolder(),
        child: Stack(
          children: [
            StreamBuilder<List<NTreeNode<Folder>>>(
              stream: _dictionaryStateBloc.foldersInView,
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



  Widget _buildRootFolderList(List<NTreeNode<Folder>> rootFolders) {
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
  Widget _buildInnerFolderList(List<NTreeNode<Folder>> folders) {
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
  Widget _buildFolderTile(NTreeNode<Folder> folder) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _dictionaryStateBloc.updateSubfolders(folder.item);
          },

          onDoubleTap: () {
            _dictionaryStateBloc.accessFolder(folder.item);
          },
        
          onSecondaryTapDown: (details) {
            WordifyOverlayEntry.showOverlay(
              [
                DoAction(
                  title: 'Create',
                  action: () { _createFolder(folder.item); }
                ),

                DoAction(
                  title: 'Update',
                  action: () { _updateFolder(folder.item); }
                ),
        
                DoAction(
                  title: 'Delete',
                  action: () { _dictionaryContentBloc.deleteFolder(folder.item); }
                )
              ], 
              context,
              details.globalPosition
            );
          },
          
          child: ListTile(
            title: Text(
              folder.item.name,
              style: TextStyle(
                color: _dictionaryStateBloc.isActivated(folder.item) ? const Color.fromARGB(255, 114, 114, 114) : Colors.black
              )
            ),
          ),
        ),

        if (folder.childrenNodes.isNotEmpty && folder.activity)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: _buildInnerFolderList(folder.childrenNodes),
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