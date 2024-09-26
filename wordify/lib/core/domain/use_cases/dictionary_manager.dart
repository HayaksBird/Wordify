import 'package:wordify/core/domain/use_cases/active_folders_state.dart';
import 'package:wordify/core/domain/use_cases/folders_content.dart';
import 'package:wordify/core/domain/use_cases/folders_in_view_state.dart';
import 'package:wordify/core/domain/use_cases/words_content.dart';

///
class DictionaryManager {
  static final DictionaryManager _instance = DictionaryManager._internal();

  late final FoldersContent foldersContent;
  late final WordsContent wordsContent;
  late final FoldersInViewState foldersInViewState;
  late final ActiveFoldersState activeFoldersState;


  factory DictionaryManager() {
    return _instance;
  }


  DictionaryManager._internal() {
    foldersContent = FoldersContent();
    wordsContent = WordsContent();
    foldersInViewState = FoldersInViewState();
    activeFoldersState = ActiveFoldersState();
  }
}