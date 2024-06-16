import 'package:wordify/features/word_tree/data/repositories/folder_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';

class FolderService {
  final FolderRepository folderRepo = FolderRepositoryImpl();


  Future<Folder> addFolder(Folder folder) async {
    return folderRepo.addFolder(folder);
  }


  Future<List<Folder>> getAllFolders() async {
    return folderRepo.getAllFolders();
  }


  Future<ExpandedFolder> getAllWords(Folder folder) async {
    return folderRepo.getAllWords(folder);
  }


  Future<ExpandedFolder> addToFolder(ExpandedFolder folder, Word word) async {
    return folderRepo.addToFolder(folder, word);
  }


  Future<ExpandedFolder> updateFolder(ExpandedFolder folder, Word oldWord, Word newWord) {
    return folderRepo.updateFolder(folder, oldWord, newWord);
  }
}