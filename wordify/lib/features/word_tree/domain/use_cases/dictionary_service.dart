import 'package:wordify/features/word_tree/domain/use_cases/active_folders_state.dart';
import 'package:wordify/features/word_tree/domain/use_cases/folder_storage.dart';
import 'package:wordify/features/word_tree/domain/use_cases/folders_in_view_state.dart';
import 'package:wordify/features/word_tree/domain/use_cases/word_storage.dart';

///
class DictionaryService {
  static final DictionaryService _instance = DictionaryService._internal();

  late final FolderStorage folderStorage;
  late final WordStorage wordStorage;
  late final FoldersInViewState foldersInViewState;
  late final ActiveFoldersState activeFoldersState;


  factory DictionaryService() {
    return _instance;
  }


  DictionaryService._internal() {
    folderStorage = FolderStorage();
    wordStorage = WordStorage();
    foldersInViewState = FoldersInViewState();
    activeFoldersState = ActiveFoldersState();
  }
}