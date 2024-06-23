import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';

///A source-ambiguous storage access point interface.
abstract class FolderRepository {
  Future<Folder> addFolder(Folder folder);
  Future<Folder> updateFolder(Folder oldFolder, Folder newFolder);
  Future<void> deleteFolder(Folder folder);
  Future<List<Folder>> getAllFolders();
  
  Future<Folder> getAllWords(Folder folder);
  Future<Folder> addToFolder(Folder folder, Word word);
  Future<Folder> deleteFromFolder(Folder folder, Word word);
  Future<Folder> updateInFolder(Folder folder, Word oldWord, Word newWord);
}