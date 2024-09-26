import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/domain/mapper/folder_mapper.dart';
import 'package:wordify/core/domain/use_cases/dictionary_manager.dart';
import 'package:wordify/features/word_tree/data/folder_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';

///Stores the changed content of the folders to the dictionary and to the DB.
class FolderStorage {
  final FolderRepository _folderRepo = FolderRepositoryImpl();
  final _foldersContent = DictionaryManager().foldersContent;
  final _foldersInViewState = DictionaryManager().foldersInViewState;


  ///Add a new folder.
  Future<void> createFolder(FolderContent? parentFolder, TempFolderContainer folder) async {
    FolderContent newFolder = await _folderRepo.addFolder(parentFolder, folder);

    _foldersContent.addNewFolder(
      parentFolder != null ? FolderMapper.toFolderModel(parentFolder) : null,
      FolderMapper.toFolderModel(newFolder),
    );
  }


  ///Change the parent folder of a folder.
  Future<FolderContent> changeParentFolder(FolderContent folder, FolderContent? parentFolder) async {
    FolderContent updatedFolder = await _folderRepo.changeParentFolder(folder, parentFolder);

    _foldersInViewState.changeFolderParent(
      parentFolder != null ? FolderMapper.toFolderModel(parentFolder) : null,
      FolderMapper.toFolderModel(updatedFolder)
    );

    return updatedFolder;
  }


  ///Update the folder content.
  Future<FolderContent> updateFolder(FolderContent oldFolder, TempFolderContainer newFolder) async {
    FolderContent updatedFolder = await _folderRepo.updateFolder(oldFolder, newFolder);
    
    _foldersContent.updateFolder(
      FolderMapper.toFolderModel(oldFolder),
      FolderMapper.toFolderModel(updatedFolder)
    );

    return updatedFolder;
  }


  ///Delete a folder with its subfolders.
  Future<List<FolderContent>> deleteFolder(FolderContent folder) async {
    List<FolderContent> subfolders = _foldersContent.deleteFolder(
      FolderMapper.toFolderModel(folder)
    );

    for (FolderContent subfolder in subfolders) {
      _folderRepo.deleteFolder(subfolder);
    }

    return subfolders;
  }
}