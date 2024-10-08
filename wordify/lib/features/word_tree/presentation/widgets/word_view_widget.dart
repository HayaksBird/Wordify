import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/animation_kit/switch_word_list_template.dart';
import 'package:wordify/core/domain/mapper/word_mapper.dart';
import 'package:wordify/core/presentation/ui_kit/buttons.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/word_view/background_widget.dart';
import 'package:wordify/features/word_tree/presentation/ui_kit/word_view/word_list_template_widget.dart';
import 'package:wordify/features/flashcards/presentation/pages/show_flashcard_page.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/pages/create_word_template_screen.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/dictionary_bloc.dart';
import 'package:wordify/features/word_tree/presentation/widgets/word_list_widget.dart';

class WordViewWidget extends StatefulWidget {
  const WordViewWidget({super.key});

  @override
  State<WordViewWidget> createState() => _WordViewWidgetState();
}

class _WordViewWidgetState extends State<WordViewWidget> {
  final _dictionaryBloc = DictionaryBloc();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FolderWords?>(
      stream: _dictionaryBloc.wordView.activeFolders,
      builder: (context, snapshot) {
        return Background(
          wordView: snapshot.connectionState != ConnectionState.waiting && snapshot.data != null ?
          _buildFolderWordsView(snapshot.data!) :
          const SizedBox.shrink()
        );
      }
    );
  }


  ///
  Widget _buildFolderWordsView(FolderWords activeFolder) {
    return Stack(
      children: [
        GestureDetector(  //Background gesture detector to switch between active folders
          onPanEnd: (details) {
            final velocity = details.velocity.pixelsPerSecond;

            //Swipe down (go up).
            if (velocity.dy > 0) {
              _dictionaryBloc.wordView.showActiveFolderAbove(activeFolder);
            }
          
            //Swipe up (go down).
            if (velocity.dy < 0) {
              _dictionaryBloc.wordView.showActiveFolderBelow(activeFolder);
            }
          },
        ),

        SwitchWordListTemplate(
          identifier: activeFolder,
          didGoBelow: _dictionaryBloc.wordView.didGoBelow,
          wordListTemplateWidget: WordListTemplateWidget( //The template witht the folder content
            key: ValueKey(activeFolder),
            path: _dictionaryBloc.folderView.getFullPath(activeFolder.folder),
            delimiter: '/',
            isBuffer: activeFolder.folder == _dictionaryBloc.folderView.bufferFolder,
            list: WordListWidget(
              activeFolder: activeFolder
            ),
            closePressed: () { _dictionaryBloc.wordView.closeFolder(activeFolder); },
            addWordPressed: () { _openWordTemplate(activeFolder.folder); },
            callFlashcards: () { _callFlashcards(activeFolder); },
          ),
        ),

        Positioned( //Add the buttons for the navigation between the active folders
          top: 10.0,
          right: 0.0,
          child: Column(
            children: [
              ArrowUpButton(onPressed: () { _dictionaryBloc.wordView.showActiveFolderAbove(activeFolder); }),
              ArrowDownButton(onPressed: () { _dictionaryBloc.wordView.showActiveFolderBelow(activeFolder); })
            ]
          )
        )
      ],
    );
  }


  ///
  void _openWordTemplate(FolderContent folder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateWordTemplate(storageFolder: folder)
      ),
    );
  }


  ///Call the flashcards feature. After it is done executing, update the view state.
  void _callFlashcards(FolderWords activeFolder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShowFlashcardPage(
          words: activeFolder.words.map((word) => WordMapper.extendWord(word)).toList(),
          path: _dictionaryBloc.folderView.getFullPath(activeFolder.folder),
        )
      ),
    ).then((_) { _dictionaryBloc.wordView.updateView(); });
  }
}