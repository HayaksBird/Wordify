import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
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
    return Material(
      color:  const Color.fromARGB(255, 194, 152, 227),
      child: StreamBuilder<List<Folder>>(
        stream: _bloc.foldersInView,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildFolderList(snapshot.data!);
          }
        }
      ),
    );
  }


  Widget _buildFolderList(List<Folder> folders) {
    return ListView.builder(
      itemCount: folders.length,
      itemBuilder: (context, index) => _buildFolderTile(folders[index])
    );
  }


  Widget _buildFolderTile(Folder folder) {
    return InkWell(
      onTap: () {
        _bloc.accessFolder(folder);
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
}