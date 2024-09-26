import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/presentation/state_management/dictionary_bloc/dictionary_bloc.dart';

///BLoC class that maintains the content of folders.
class FolderContentBloc {

  ///Create folder.
  Future<void> createFolder(FolderContent? parentFolder, TempFolderContainer folder) async {
    await dictionaryService.folderStorage.createFolder(parentFolder, folder);

    updateFolderView();
  }


  ///Update the folder.
  ///In addition change folder's parent if necessary. 
  Future<void> updateFolder(FolderContent oldFolder, TempFolderContainer newFolder, FolderContent? newParentFolder) async {
    FolderContent updatedFolder = await dictionaryService.folderStorage.updateFolder(oldFolder, newFolder);

    if (dictionaryService.foldersInViewState.getParent(updatedFolder) == newParentFolder) {
      if (expandedFolders.contains(oldFolder)) {
        expandedFolders.remove(oldFolder);
        expandedFolders.add(updatedFolder);
      }
    } else {  ///Folder's parent folder has changed
      FolderContent updatedFolderWithNewParent = await dictionaryService.folderStorage.changeParentFolder(updatedFolder, newParentFolder);
      
      if (expandedFolders.contains(oldFolder)) {
        expandedFolders.remove(oldFolder);
        expandedFolders.add(updatedFolderWithNewParent);
      }
    }

    updateWordView(); 
    updateFolderView();
  }


  ///Remove the folder with all of its subfolders.
  ///Note that the subfolders are also removed from the expandedFolders
  ///list to not take the space.
  Future<void> deleteFolder(FolderContent folder) async {
    List<FolderContent> subfolders = await dictionaryService.folderStorage.deleteFolder(folder);

    for (var subfolder in subfolders) {
      expandedFolders.remove(subfolder);
    }

    updateWordView();
    updateFolderView();
  }
}