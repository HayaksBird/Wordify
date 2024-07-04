import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/folder_presentation.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/widgets/folder_content_widget.dart';

class WordListWidget extends StatefulWidget {
  const WordListWidget({super.key});

  @override
  State<WordListWidget> createState() => _WordListWidgetState();
}

class _WordListWidgetState extends State<WordListWidget> {
  final _bloc = DictionaryBloc();

  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FolderWords>>(
      stream: _bloc.activeFolders,
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