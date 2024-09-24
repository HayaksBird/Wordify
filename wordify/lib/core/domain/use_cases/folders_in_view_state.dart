import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/domain/entities/dictionary.dart';
import 'package:wordify/core/util/n_tree.dart';

///Manage the folders in view list.
class FoldersInViewState {
  final Dictionary _dictionary = Dictionary();
  

  ///Set the folders in view by proving the root folders.
  void setRootFolders(List<FolderModel> rootFolders) {
    _dictionary.foldersInView = NTree<FolderModel>()..setRoot(rootFolders);
  }


  ///Provide the subfolders for a folder.
  void setFoldersChildren(FolderModel parentFolder, List<FolderModel> children) {
    _dictionary.foldersInView.insert(parentFolder, children);
  }

  
  ///Reshape the folder tree by changing the parent of a certain folder.
  void changeFolderParent(FolderModel? newParentFolder, FolderModel folder) {
    _dictionary.foldersInView.changeParent(newParentFolder, folder);
  }


  ///
  bool doesHaveChildren(FolderModel folder) => _dictionary.foldersInView.containsChildren(folder);


  ///
  List<FolderModel> getRootFolders() => _dictionary.foldersInView.getRootItems;


  ///
  List<FolderModel> getChildren(FolderModel folder) => _dictionary.foldersInView.getChildren(folder);


  ///
  FolderModel? getParent(FolderModel folder) => _dictionary.foldersInView.getParent(folder);


  ///
  List<FolderModel> getSiblingsInclusive(FolderModel folder) => _dictionary.foldersInView.getSiblingsInclusive(folder);


  ///
  List<FolderModel> getSiblingsExclusive(FolderModel folder) => _dictionary.foldersInView.getSiblingsExclusive(folder);
  

  ///
  String fullPath(FolderModel folder) => _dictionary.foldersInView.getPathToItem(folder, (f) => f.name);
}