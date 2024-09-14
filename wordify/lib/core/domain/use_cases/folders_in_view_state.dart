import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/domain/entities/dictionary.dart';
import 'package:wordify/core/util/n_tree.dart';

class FoldersInViewState {
  final Dictionary _dictionary = Dictionary();
  

  ///
  void setRootFolders(List<FolderModel> rootFolders) {
    _dictionary.foldersInView = NTree<FolderModel>()..setRoot(rootFolders);
  }


  ///
  void setFoldersChildren(FolderModel parentFolder, List<FolderModel> children) {
    _dictionary.foldersInView.insert(parentFolder, children);
  }


  ///
  String fullPath(FolderModel folder) {
    return _dictionary.foldersInView.getPathToItem(folder, (f) => f.name);
  } 
}