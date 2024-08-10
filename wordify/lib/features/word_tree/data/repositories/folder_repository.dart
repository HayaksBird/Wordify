import 'package:wordify/features/word_tree/data/data_sources/folder_persistence.dart';
import 'package:wordify/features/word_tree/data/model/folder_model.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';

class FolderRepositoryImpl implements FolderRepository {
  static final FolderRepositoryImpl _instance = FolderRepositoryImpl._internal();


  factory FolderRepositoryImpl() {
    return _instance;
  }


  FolderRepositoryImpl._internal();


  ///
  @override
  Future<Folder> addFolder(Folder? parentFolder, Folder folder) async {
    FolderModel? parentFolderModel = parentFolder as FolderModel?;
    FolderModel folderModel = FolderModel.fromFolder(folder);

    FolderModel newFolderModel = folderModel.copyWith(
      parentId: parentFolderModel?.id
    );

    return FolderPersistence.insert(newFolderModel);
  }


  ///
  @override
  Future<void> deleteFolder(Folder folder) async {
    await FolderPersistence.delete(folder as FolderModel);
  }


  ///
  @override
  Future<List<Folder>> getRootFolders() async {
    return FolderPersistence.getRootFolders();
  }
  

  ///
  @override
  Future<List<Folder>> getChildFolders(Folder folder) {
    FolderModel folderModel = folder as FolderModel;

    return FolderPersistence.getFolders(folderModel.id);
  }


  ///
  @override
  Future<Folder> getBuffer() {
    return FolderPersistence.getBufferFolder();
  }

  
  ///
  @override
  Future<Folder> updateFolder(Folder oldFolder, Folder newFolder) async {
    FolderModel oldFolderModel = oldFolder as FolderModel;

    FolderModel newFolderModel = oldFolderModel.copyWith(
      name: newFolder.name
    );

    await FolderPersistence.update(newFolderModel);

    return newFolderModel;
  }
}