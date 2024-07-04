import 'package:wordify/features/word_tree/data/repositories/folder_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';

class FolderService {
  final FolderRepository folderRepo = FolderRepositoryImpl();


  Future<Folder> addFolder(Folder? parentFolder, Folder folder) async {
    return folderRepo.addFolder(parentFolder, folder);
  }


  Future<void> deleteFolder(Folder folder) async {
    folderRepo.deleteFolder(folder);
  }


  Future<Folder> updateFolder(Folder oldFolder, Folder newFolder) async {
    return folderRepo.updateFolder(oldFolder, newFolder);
  }


  Future<List<Folder>> getRootFolders() async {
    return folderRepo.getRootFolders();
  }


  Future<List<Folder>> getChildFolders(Folder folder) async {
    return folderRepo.getChildFolders(folder);
  }
}