import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';

///A source-ambiguous storage access point interface.
abstract class FolderRepository {
  Future<Folder> addFolder(Folder folder);
  Future<List<Folder>> getAllFolders();
  
  Future<Folder> getAllWords(Folder folder);
  Future<Folder> addToFolder(Folder folder, Word word);
  Future<Folder> updateFolder(Folder folder, Word oldWord, Word newWord);
}