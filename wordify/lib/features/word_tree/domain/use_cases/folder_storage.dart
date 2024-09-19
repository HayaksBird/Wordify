import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/domain/mapper/folder_mapper.dart';
import 'package:wordify/core/domain/use_cases/dictionary_manager.dart';
import 'package:wordify/features/word_tree/data/folder_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';

///FOLDERS OPERATION MANAGER FOR DICTIONARY
class FolderStorage {
  final FolderRepository _folderRepo = FolderRepositoryImpl();
  final _foldersContent = DictionaryManager().foldersContent;


  ///Add a new folder.
  Future<void> createFolder(FolderContent? parentFolder, TempFolderContainer folder) async {
    FolderContent newFolder = await _folderRepo.addFolder(parentFolder, folder);

    _foldersContent.addNewFolder(
      parentFolder != null ? FolderMapper.toFolderModel(parentFolder) : null,
      FolderMapper.toFolderModel(newFolder),
    );
  }


  ///
  Future<FolderContent> updateFolder(FolderContent oldFolder, TempFolderContainer newFolder) async {
    FolderContent updatedFolder = await _folderRepo.updateFolder(oldFolder, newFolder);
    
    _foldersContent.updateFolder(
      FolderMapper.toFolderModel(oldFolder),
      FolderMapper.toFolderModel(updatedFolder)
    );

    return updatedFolder;
  }


  ///Delete a folder with its subfolders.
  ///Remove them from the cache and/or active folder list
  ///if they are present there.
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