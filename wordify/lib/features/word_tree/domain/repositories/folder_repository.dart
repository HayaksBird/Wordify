import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///A source-ambiguous storage access point interface.
abstract class FolderRepository {
  ///Create a new folder.
  Future<FolderContent> addFolder(FolderContent? parentFolder, TempFolderContainer folder);
  ///Update a folder.
  Future<FolderContent> updateFolder(FolderContent oldFolder, TempFolderContainer newFolder);
  ///Delete a folder.
  Future<void> deleteFolder(FolderContent folder);
  ///Get a list of root folders in the system.
  Future<List<FolderContent>> getRootFolders();
  ///Get a list of all child folders of a certain folder.
  Future<List<FolderContent>> getChildFolders(FolderContent folder);
  ///Get the buffer folder.
  Future<FolderContent> getBuffer();
}