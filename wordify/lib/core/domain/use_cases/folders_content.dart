import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/domain/entities/dictionary.dart';

///Manage the folder content of a dictionary.
class FoldersContent {
  final Dictionary _dictionary = Dictionary();


  ///Add a new folder to the dictionary.
  void addNewFolder(FolderModel? parentFolder, FolderModel folder) {
    _dictionary.foldersInView.insertOne(parentFolder, folder);
  }


  ///Update the content of a certain folder.
  void updateFolder(FolderModel oldFolder, FolderModel updatedFolder) {
    List<FolderModel> subfolders = _dictionary.foldersInView.getSubitems(oldFolder);

    for (FolderModel subfolder in subfolders) {
      _dictionary.activeFolders.remove(subfolder);
      _dictionary.cachedFolders.remove(subfolder);
    }

    _dictionary.foldersInView.update(oldFolder, updatedFolder);
  }


  ///Delete a folder.
  List<FolderModel> deleteFolder(FolderModel folder) {
    List<FolderModel> subfolders = _dictionary.foldersInView.getSubitems(folder);

    for (FolderModel subfolder in subfolders) {
      _dictionary.activeFolders.remove(subfolder);
      _dictionary.cachedFolders.remove(subfolder);
    }

    _dictionary.foldersInView.delete(folder);

    return subfolders;
  }
}