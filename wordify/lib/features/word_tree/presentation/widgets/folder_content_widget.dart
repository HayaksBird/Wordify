import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/components.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';

//Needs bloc only if adds, updates words
class FolderContentWidget extends StatelessWidget {
  final Folder folder;
  final _bloc = DictionaryBloc();


  FolderContentWidget({super.key, required this.folder});


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FolderHeader(
          name: folder.name,
          closePressed: () {
            _bloc.closeFolder(folder);
          }
        ),
        Expanded(child: _buildWordList())
      ],
    );
  }


  ///
  Widget _buildWordList() {
    return ListView.builder(
      itemCount: folder.words.length,
      itemBuilder: (context, index) => _buildFolderTile(folder.words[index])
    );
  }


  ///
  Widget _buildFolderTile(Word word) {
    return ListTile (
      title: Text(word.word),
      subtitle: Text(word.translation)
    );
  }
}