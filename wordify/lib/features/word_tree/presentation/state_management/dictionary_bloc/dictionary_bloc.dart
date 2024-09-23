import 'dart:async';
import 'dart:collection';
import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_service.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/folder_content_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/folder_view_state_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/word_content_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/word_view_state_bloc.dart';


final foldersInViewController = StreamController<List<FolderContent>>(); //StreamController for output
final activeFoldersController = StreamController<FolderWords?>(); //StreamController for output 
final DictionaryService dictionaryService = DictionaryService();
final HashSet<FolderContent> expandedFolders = HashSet<FolderContent>();
final HashSet<WordContent> activeSentences = HashSet<WordContent>();


///
void updateWordView() {
  activeFoldersController.sink.add(dictionaryService.activeFoldersState.currentActiveFolder);
}


///
void updateFolderView() {
  foldersInViewController.sink.add(dictionaryService.foldersInViewState.getRootFolders());
}



///
class DictionaryBloc {
  static final DictionaryBloc _instance = DictionaryBloc._internal();
  
  late final WordViewStateBloc wordView;
  late final FolderViewStateBloc folderView;
  late final FolderContentBloc folderContent;
  late final WordContentBloc wordContent;


  void dispose() {
    foldersInViewController.close();
    activeFoldersController.close();
  }


  factory DictionaryBloc() {
    return _instance;
  }


  DictionaryBloc._internal() {
    wordView = WordViewStateBloc();
    folderView = FolderViewStateBloc();
    folderContent = FolderContentBloc();
    wordContent = WordContentBloc();
  }
}