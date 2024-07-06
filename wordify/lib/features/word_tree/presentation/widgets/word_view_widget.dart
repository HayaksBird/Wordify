import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/folder_presentation.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';
import 'package:wordify/features/word_tree/presentation/pages/word_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';

class WordViewWidget extends StatefulWidget {
  const WordViewWidget({super.key});

  @override
  State<WordViewWidget> createState() => _WordViewWidgetState();
}

class _WordViewWidgetState extends State<WordViewWidget> {
  final _dictionaryBloc = DictionaryBloc();

  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FolderWords>>(
      stream: _dictionaryBloc.state.activeFolders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        } else {
          return _buildAccessedFoldersTiles(snapshot.data!);
        }
      }
    );
  }


  ///
  Widget _buildAccessedFoldersTiles(List<FolderWords> activeFolders) {
    return ListView.builder(
      itemCount: activeFolders.length,
      itemBuilder: (context, index) => _buildWordsTile(activeFolders[index])
    );
  }


  ///
  Widget _buildWordsTile(FolderWords activeFolder) {
    return FolderContentTemplate(
      folderContent: FolderContentWidget(activeFolder: activeFolder)
    );
  }
}



//Needs bloc only if adds, updates words
class FolderContentWidget extends StatelessWidget {
  final _dictionaryBloc = DictionaryBloc();
  final FolderWords activeFolder;


  FolderContentWidget({super.key, required this.activeFolder});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FolderHeader(
          name: _dictionaryBloc.state.getFullPath(activeFolder.folder),
          closePressed: () { _dictionaryBloc.state.closeFolder(activeFolder); }
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
      child: ListTile(
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