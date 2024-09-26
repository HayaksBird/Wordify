import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/dictionary_bloc.dart';

///BLoC class that maintains the state of the folder view.
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
  void toggleFolder(bool isFolderViewExpanded, int layer, FolderContent folder) {
    ///If the folder view is not expanded, the current folder does contain subfolders, and
    ///the current tree depth is 3 (layer 2) then simply add the folder to the expanded list
    ///if it is not there because the view is about to expand.
    if (!isFolderViewExpanded && layer == 2 && dictionaryService.foldersInViewState.doesHaveChildren(folder)) {
      if (!expandedFolders.contains(folder)) { expandedFolders.add(folder); }
    ///If we do not have the case mentioned above then simply toggle the folder.
    ///Note that the folder can only be expanded if it has subfolders.
    } else {
      if (dictionaryService.foldersInViewState.doesHaveChildren(folder)) {
        if (!expandedFolders.contains(folder)) {
          expandedFolders.add(folder);
        } else { expandedFolders.remove(folder); }

        updateFolderView();
      }
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


  ///Trigger the expand if the folder view is not expanded, the current folder
  ///does contain subfolders, and the current tree depth is 3 (layer 2)
  bool triggerExpand(bool isFolderViewExpanded, int layer, FolderContent folder) {
    return !isFolderViewExpanded && layer == 2 && dictionaryService.foldersInViewState.doesHaveChildren(folder);
  }

  
  ///If the folder view is in the shrinked view then show at max 2 layers.
  ///(The layer count starts at 0).
  bool canShowSubfolders(bool isFolderViewExpanded, int layer) {
    if (!isFolderViewExpanded && layer >= 2) { return false; }
    else { return true; }
  }


  ///Get a list of subfolders of a certain folder.
  List<FolderContent> getSubfolders(FolderContent? folder) {
    if (folder == null) { //if null then show the root folders
      return dictionaryService.foldersInViewState.getRootFolders();
    } else {
      return dictionaryService.foldersInViewState.getChildren(folder);
    }
  }


  ///Get a list of subfolders of a certain folder with a provided exception folder.
  ///Meaning, if the exception folder is in the list then remove it.
  List<FolderContent> getSubfoldersWithException(FolderContent? folder, FolderContent exceptionFolder) {
    if (folder == null) { //if null then show the root folders
      return dictionaryService.foldersInViewState.getRootFolders()..remove(exceptionFolder);
    } else {
      return dictionaryService.foldersInViewState.getChildren(folder)..remove(exceptionFolder);
    }
  }


  ///Get a parent folder of the provided folder. Note that if the root folder is given,
  ///then the parent is null.
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