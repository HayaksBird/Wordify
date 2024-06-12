import 'package:wordify/features/word_tree/data/repositories/folder_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';

class FolderService {
  final FolderRepository folderRepo = FolderRepositoryImpl();


  Future<Folder> addFolder(Folder folder) async {
    return folderRepo.addFolder(folder);
  }


  Future<List<Folder>> getAllFolders() async {
    return folderRepo.getAllFolders();
  }


  Future<Folder> getAllWords(Folder folder) async {
    return folderRepo.getAllWords(folder);
  } 
}