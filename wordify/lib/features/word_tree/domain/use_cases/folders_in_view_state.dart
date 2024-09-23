import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/domain/mapper/folder_mapper.dart';
import 'package:wordify/core/domain/use_cases/dictionary_manager.dart';
import 'package:wordify/features/word_tree/data/folder_repository.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';

///Manages the state of the folders in view of the dictionary.
///Handles all the operations that have to do with the state of the
///folders in view.
class FoldersInViewState {
  final FolderRepository _folderRepo = FolderRepositoryImpl();
  final _foldersInViewState = DictionaryManager().foldersInViewState;


  ///Initialize the dictionary with the folder tree.
  Future<void> setFolderTree() async {
    List<FolderContent> rootFolders = await _folderRepo.getRootFolders();

   _foldersInViewState.setRootFolders(
      rootFolders.map((folder) => FolderMapper.toFolderModel(folder)).toList()
    );

    for (FolderContent rootFolder in rootFolders) {
      await _setFolderSubtree(rootFolder);
    }
  }


  ///Set all the subfolders of a certain folder.
  Future<void> _setFolderSubtree(FolderContent folder) async {
    List<FolderContent> subfolders = await _folderRepo.getChildFolders(folder);

    if (subfolders.isNotEmpty) {
      _foldersInViewState.setFoldersChildren(
        FolderMapper.toFolderModel(folder),
        subfolders.map((folder) => FolderMapper.toFolderModel(folder)).toList()
      );

      for (FolderContent subfolder in subfolders) {
        _setFolderSubtree(subfolder);
      }
    }
  }


  ///
  bool doesHaveChildren(FolderContent folder) => _foldersInViewState.doesHaveChildren(FolderMapper.toFolderModel(folder));


  ///
  List<FolderContent> getRootFolders() => _foldersInViewState.getRootFolders();


  ///
  List<FolderContent> getChildren(FolderContent folder) => _foldersInViewState.getChildren(FolderMapper.toFolderModel(folder));


  ///
  FolderContent? getParent(FolderContent folder) => _foldersInViewState.getParent(FolderMapper.toFolderModel(folder));


  ///
  List<FolderContent> getSiblingsInclusive(FolderContent folder) => _foldersInViewState.getSiblingsInclusive(FolderMapper.toFolderModel(folder));


  ///
  List<FolderContent> getSiblingsExclusive(FolderContent folder) => _foldersInViewState.getSiblingsExclusive(FolderMapper.toFolderModel(folder));


  ///
  String fullPath(FolderContent folder) => _foldersInViewState.fullPath(FolderMapper.toFolderModel(folder));
}