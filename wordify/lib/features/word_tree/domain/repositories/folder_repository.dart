import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/entities/word.dart';

///A source-ambiguous storage access point interface.
abstract class FolderRepository {
  Future<Folder> addFolder(Folder folder);
  Future<List<Folder>> getAllFolders();
  Future<ExpandedFolder> getAllWords(Folder folder);
  Future<ExpandedFolder> addToFolder(ExpandedFolder folder, Word word);
  Future<ExpandedFolder> updateFolder(ExpandedFolder folder, Word oldWord, Word newWord);
}