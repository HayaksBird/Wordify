import 'package:wordify/features/word_tree/domain/use_cases/dictionary_content_manager.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_state_manager.dart';

///Manages the dictionary of the app. The management is split between state management of the
///dictionary (how is the dictionary presented) and content management (what exists within the
///dictionary).
class DictionaryManager {
  static final DictionaryManager _instance = DictionaryManager._internal();

  late final DictionaryFoldersInViewStateManager foldersInViewState;
  late final DictionaryActiveFolderStateManager activeFolderState;
  late final DictionaryWordsManager words;
  late final DictionaryFoldersManager folders;


  factory DictionaryManager() {
    return _instance;
  }


  DictionaryManager._internal() {
    foldersInViewState = DictionaryFoldersInViewStateManager();
    activeFolderState = DictionaryActiveFolderStateManager();
    words = DictionaryWordsManager();
    folders = DictionaryFoldersManager();
  }
}