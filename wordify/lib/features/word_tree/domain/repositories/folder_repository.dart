import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///A source-ambiguous storage access point interface.
abstract class FolderRepository {
  ///Create a new folder.
  Future<Folder> addFolder(Folder folder);
  ///Update a folder.
  Future<Folder> updateFolder(Folder oldFolder, Folder newFolder);
  ///Delete a folder.
  Future<void> deleteFolder(Folder folder);
  ///Get a list of root folders in the system.
  Future<List<Folder>> getRootFolders();
  ///Get a list of all child folders of a certain folder.
  Future<List<Folder>> getChildFolders(Folder folder);
}