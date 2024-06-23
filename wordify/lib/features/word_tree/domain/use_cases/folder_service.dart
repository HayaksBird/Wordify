import 'package:wordify/features/word_tree/data/repositories/folder_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';

class FolderService {
  final FolderRepository folderRepo = FolderRepositoryImpl();


  Future<Folder> addFolder(Folder folder) async {
    return folderRepo.addFolder(folder);
  }


  Future<void> deleteFolder(Folder folder) async {
    folderRepo.deleteFolder(folder);
  }


  Future<Folder> updateFolder(Folder oldFolder, Folder newFolder) async {
    return folderRepo.updateFolder(oldFolder, newFolder);
  }


  Future<List<Folder>> getAllFolders() async {
    return folderRepo.getAllFolders();
  }


  Future<Folder> getAllWords(Folder folder) async {
    return folderRepo.getAllWords(folder);
  }


  Future<Folder> addToFolder(Folder folder, Word word) async {
    return folderRepo.addToFolder(folder, word);
  }


  Future<Folder> updateInFolder(Folder folder, Word oldWord, Word newWord) async {
    return folderRepo.updateInFolder(folder, oldWord, newWord);
  }


  Future<Folder> deleteFromFolder(Folder folder, Word word) async {
    return folderRepo.deleteFromFolder(folder, word);
  }
}