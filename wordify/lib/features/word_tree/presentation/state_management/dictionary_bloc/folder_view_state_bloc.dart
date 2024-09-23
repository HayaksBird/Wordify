import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/dictionary_bloc.dart';

///BLoC class to work with the dictionary. It serves as an intermediary between
///the domain and the UI.
class FolderViewStateBloc {
  bool _showBuffer = true;
  FolderContent? _selectedFolder;  //The folder selected by the right click
  

  ///Set the folder tree and the buffer folder.
  Future<void> loadFolders() async {
    await dictionaryService.foldersInViewState.setFolderTree();
    await dictionaryService.activeFoldersState.setBufferFolder();
    updateFolderView();
  }


  ///Expand the folder if it is not expanded, or shrink it if it is expanded.
  void toggleFolder(FolderContent folder) {
    if (dictionaryService.foldersInViewState.doesHaveChildren(folder)) {
      if (!expandedFolders.contains(folder)) {
        expandedFolders.add(folder);
      } else { expandedFolders.remove(folder); }

      updateFolderView();
    }
  }


  ///Get full path of the folder from root
  String getFullPath(FolderContent? folder) {
    if (folder != null && folder != dictionaryService.activeFoldersState.bufferFolder) {
      return dictionaryService.foldersInViewState.fullPath(folder);
    } else { return ''; } //buffer folder
  }


  ///Can show child folders?
  bool isToExpand(FolderContent folder) {
    return expandedFolders.contains(folder) && dictionaryService.foldersInViewState.doesHaveChildren(folder);
  }


  ///
  List<FolderContent> getSubfolders(FolderContent? folder) {
    if (folder == null) { //if null then show the root folders
      return dictionaryService.foldersInViewState.getRootFolders();
    } else {
      return dictionaryService.foldersInViewState.getChildren(folder);
    }
  }


  ///
  List<FolderContent> getSubfoldersWithException(FolderContent? folder, FolderContent exceptionFolder) {
    if (folder == null) { //if null then show the root folders
      return dictionaryService.foldersInViewState.getRootFolders()..remove(exceptionFolder);
    } else {
      return dictionaryService.foldersInViewState.getChildren(folder)..remove(exceptionFolder);
    }
  }


  ///
  FolderContent? getParentFolder(FolderContent folder) {
    return dictionaryService.foldersInViewState.getParent(folder);
  }


  ///To prevent the slowdown of onTap due to GestureDetector's onDoubleTap
  ///we nullify the onDoubleTap when the IconButton of the folder tile
  ///is hovered.
  void allowBufferView(bool permission) {
    _showBuffer = permission;
    updateFolderView();
  }


  ///The folder that is currently selected with the right click of the
  ///mouse.
  void setSelectedFolder(FolderContent? folder) {
    _selectedFolder = folder;
    updateFolderView();
  }


  //GETTERS
  Stream<List<FolderContent>> get foldersInView => foldersInViewController.stream;

  FolderContent get bufferFolder => dictionaryService.activeFoldersState.bufferFolder!;

  bool get canShowBuffer => _showBuffer;

  FolderContent? get getSelectedFolder => _selectedFolder;
}