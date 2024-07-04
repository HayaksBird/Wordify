import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/folder_presentation.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';
import 'package:wordify/features/word_tree/presentation/pages/update_word_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';

//Needs bloc only if adds, updates words
class FolderContentWidget extends StatelessWidget {
  final FolderWords activeFolder;
  final _dictionaryBloc = DictionaryBloc();


  FolderContentWidget({super.key, required this.activeFolder});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FolderHeader(
          name: _dictionaryBloc.getFullPath(activeFolder),
          closePressed: () { _dictionaryBloc.closeFolder(activeFolder); }
        ),
        Expanded(child: _buildWordList(context))
      ],
    );
  }


  ///
  Widget _buildWordList(BuildContext context) {
    return ListView.builder(
      itemCount: activeFolder.words.length,
      itemBuilder: (context, index) => _buildFolderTile(context, activeFolder.words[index])
    );
  }


  ///
  Widget _buildFolderTile(BuildContext context, Word word) {
    return InkWell(
      onTap: () { //If clicked, open the corresponding template
        _openWordTemplate(context, word);
      },
      child: ListTile (
        title: Text(word.word),
        subtitle: Text(word.translation)
      ),
    );
  }


  ///
  void _openWordTemplate(BuildContext context, Word word) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UpdateWordTemplate(
          word: word,
          expandedFolder: activeFolder,
        )
      ),
    );
  }
}