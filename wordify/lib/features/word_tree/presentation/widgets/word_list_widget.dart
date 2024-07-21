import 'package:flutter/material.dart';
import 'package:wordify/core/ui_kit/components.dart';
import 'package:wordify/core/ui_kit/word_view/word_tile_widget.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';
import 'package:wordify/features/word_tree/presentation/pages/update_word_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc.dart';


///Create the list of words presented in the word view.
class WordListWidget extends StatefulWidget {
  final List<Word> words;
  final FolderWords activeFolder;


  const WordListWidget({ 
    super.key,
    required this.words,
    required this.activeFolder
  });


  @override
  State<WordListWidget> createState() => _WordListWidgetState();
}

class _WordListWidgetState extends State<WordListWidget> {
  late List<Word> words;
  late FolderWords activeFolder;
  Word? selectedWord;
  final _dictionaryBloc = DictionaryBloc();


  @override
  Widget build(BuildContext context) {
    words = widget.words;
    activeFolder = widget.activeFolder;

    return _buildList();
  }


  ///
  Widget _buildList() {
    return ListView.builder(
      itemCount: words.length,
      itemBuilder: (context, index) => _buildFolderTile(context, words[index])
    );
  }


  ///
  Widget _buildFolderTile(BuildContext context, Word word) {
    return GestureDetector(
      onSecondaryTapDown: (details) {
        setState(() {
          selectedWord = word;
        });
        _showOverlay(context, details, word);
      },
      child: WordTileWidget(
        word: word.word,
        translation: word.translation,
        isSelected: selectedWord == word ? true : false,
      ),
    );
  }


  ///Show the overlay for the right click
  void _showOverlay(BuildContext context, TapDownDetails details, Word word) {
    WordifyOverlayEntry.showOverlay(
      inputs: [
        DoAction(
          title: 'Update',
          action: () { _openWordTemplate(context, word); }
        ),

        DoAction(
          title: 'Delete',
          action: () { _dictionaryBloc.content.deleteWord(activeFolder, word); }
        )
      ], 
      context:  context,
      tapPosition:  details.globalPosition,
      onOverlayClosed: _overlayClosed
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


  ///Unselect the word
  void _overlayClosed() {
    setState(() {
      selectedWord = null;
    });
  }
}