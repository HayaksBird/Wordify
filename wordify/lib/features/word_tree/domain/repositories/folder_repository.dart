import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///A source-ambiguous storage access point interface.
abstract class FolderRepository {
  Future<Folder> addFolder(Folder folder);
  Future<List<Folder>> getAllFolders();
  Future<Folder> getAllWords(Folder folder);
}