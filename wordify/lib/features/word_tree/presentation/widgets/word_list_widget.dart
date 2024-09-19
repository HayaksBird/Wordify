import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/word_view/word_actions_overlay.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/word_view/word_tile_widget.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/pages/update_word_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';

///Create the list of words presented in the word view.
class WordListWidget extends StatelessWidget {
  final FolderWords activeFolder;
  final _dictionaryBloc = DictionaryBloc();


  WordListWidget({
    super.key,
    required this.activeFolder
  });


  @override
  Widget build(BuildContext context) {
    return _buildList();
  }


  ///
  Widget _buildList() {
    return ListView.builder(
      itemCount: activeFolder.words.length,
      itemBuilder: (context, index) => _buildFolderTile(context, activeFolder.words[index])
    );
  }


  ///
  Widget _buildFolderTile(BuildContext context, WordContent word) {
    return GestureDetector(
      onTap: () {
        _dictionaryBloc.wordView.toggleSentence(word);
      },
      onSecondaryTapDown: (details) {
        _dictionaryBloc.wordView.setSelectedWord(word);
        _showOverlay(context, details, word);
      },
      child: WordTileWidget(
        word: word.word,
        translation: word.translation,
        sentence: word.sentence,
        isSelected: _dictionaryBloc.wordView.getSelectedWord == word ? true : false,
        showSentence: _dictionaryBloc.wordView.doShowSentence(word),
      ),
    );
  }


  ///Show the overlay for the right click
  void _showOverlay(BuildContext context, TapDownDetails details, WordContent word) {
    WordActionsOverlay.showOverlay(
      update: () { _openWordTemplate(context, word); },
      delete: () { _dictionaryBloc.content.deleteWord(activeFolder, word); },
      position: details.globalPosition,
      onOverlayClosed: _overlayClosed,
      context: context
    );
  }


  ///
  void _openWordTemplate(BuildContext context, WordContent word) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UpdateWordTemplate(
          word: word,
          expandedFolder: activeFolder,
        )
      ),
    );
  }


  ///Unselect the word
  void _overlayClosed() {
    _dictionaryBloc.wordView.setSelectedWord(null);
  }
}