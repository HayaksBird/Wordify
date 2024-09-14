import 'package:wordify/core/domain/mapper/folder_mapper.dart';
import 'package:wordify/core/domain/use_cases/dictionary_manager.dart';
import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/data/folder_repository.dart';
import 'package:wordify/core/domain/entities/dictionary.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';

///Manages the state of the folders in view of the dictionary.
///Handles all the operations that have to do with the state of the
///folders in view.
class FoldersInViewState {
  final Dictionary _dictionary = Dictionary();
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
  String fullPath(FolderContent folder) {
    return _foldersInViewState.fullPath(FolderMapper.toFolderModel(folder));
  }


  //GETTERS
  ///
  NTree<FolderContent> get foldersInView => _dictionary.foldersInView; 

  FolderContent? get bufferFolder => _dictionary.buffer?.folder;
}