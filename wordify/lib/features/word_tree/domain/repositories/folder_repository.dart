import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';

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
  
  ///Fill up the folder with words.
  Future<Folder> getAllWords(Folder folder);
  ///Add a word to a folder and return the updated version of the folder.
  Future<Folder> addToFolder(Folder folder, Word word);
  ///Delete a word from a folder and return the updated version of the folder.
  Future<Folder> deleteFromFolder(Folder folder, Word word);
  ///Update a word in a folder and return the updated version of the folder.
  Future<Folder> updateInFolder(Folder folder, Word oldWord, Word newWord);
}