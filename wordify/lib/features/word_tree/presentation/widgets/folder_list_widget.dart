import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/components.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/pages/create_folder_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/pages/update_folder_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';


///Present the list of type FolderContentWidget,
///showing all words in an active folder list.
class FolderListWidget extends StatefulWidget {
  const FolderListWidget({super.key});

  @override
  State<FolderListWidget> createState() => _FolderListWidgetState();
}


class _FolderListWidgetState extends State<FolderListWidget> {
  final _bloc = DictionaryBloc();


  @override
  void initState() {
    super.initState();
    _bloc.loadFolders();
  }


  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FoolderList(
      child: GestureDetector(
        onSecondaryTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CreateFolderTemplate()
            ),
          );
        },

        child: Stack(
          children: [
            StreamBuilder<List<Folder>>(
              stream: _bloc.foldersInView,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return _buildFolderList(snapshot.data!);
                }
              },
            )
          ],
        )
      )
    );
  }



  Widget _buildFolderList(List<Folder> folders) {
    return ListView.builder(
      itemCount: folders.length,
      itemBuilder: (context, index) => _buildFolderTile(folders[index])
    );
  }


  Widget _buildFolderTile(Folder folder) {
    return GestureDetector(
      onTap: () {
        _bloc.accessFolder(folder);
      },

      onSecondaryTapDown: (details) {
        WordifyOverlayEntry.showOverlay(
          [
            DoAction(
              title: 'Update',
              action: () { _updateFolder(folder); }
            ),

            DoAction(
              title: 'Delete',
              action: () { _bloc.deleteFolder(folder); }
            )
          ], 
          context,
          details.globalPosition
        );
      },
      
      child: ListTile(
        title: Text(
          folder.name,
          style: TextStyle(
            color: _bloc.isActivated(folder.name) ? const Color.fromARGB(255, 114, 114, 114) : Colors.black
          )
        ),
      ),
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
}