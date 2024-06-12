import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';


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
  Widget build(BuildContext context) {
    return StreamBuilder<List<Folder>>(
      stream: _bloc.foldersInView,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return _buildFolderList(snapshot.data!);
        }
      }
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
        title: Text(folder.name),
      ),
    );
  }
}