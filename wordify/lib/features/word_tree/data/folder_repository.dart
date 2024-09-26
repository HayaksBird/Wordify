import 'package:wordify/core/data/data_sources/folder_persistence.dart';
import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/domain/entities/folder.dart';
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
  Future<FolderContent> addFolder(FolderContent? parentFolder, TempFolderContainer folder) async {
    FolderModel? parentFolderModel = parentFolder as FolderModel?;

    return FolderPersistence.insert(
      parentId: parentFolderModel?.id,
      name: folder.name
    );
  }


  ///
  @override
  Future<void> deleteFolder(FolderContent folder) async {
    await FolderPersistence.delete(folder as FolderModel);
  }


  ///
  @override
  Future<List<FolderContent>> getRootFolders() async {
    return FolderPersistence.getRootFolders();
  }
  

  ///
  @override
  Future<List<FolderContent>> getChildFolders(FolderContent folder) {
    FolderModel folderModel = folder as FolderModel;

    return FolderPersistence.getFolders(folderModel.id);
  }


  ///
  @override
  Future<FolderContent> getBuffer() {
    return FolderPersistence.getBufferFolder();
  }

  
  ///
  @override
  Future<FolderContent> updateFolder(FolderContent oldFolder, TempFolderContainer newFolder) async {
    FolderModel oldFolderModel = oldFolder as FolderModel;

    FolderModel newFolderModel = oldFolderModel.copyWith(
      name: newFolder.name
    );

    await FolderPersistence.update(newFolderModel);

    return newFolderModel;
  }
  

  ///
  @override
  Future<FolderContent> changeParentFolder(FolderContent folder, FolderContent? parentFolder) async {
    FolderModel oldFolderModel = folder as FolderModel;
    FolderModel? parentFolderModel = parentFolder as FolderModel?;

    FolderModel newFolderModel = oldFolderModel.copyWith(
      parentId: parentFolderModel?.id
    );

    await FolderPersistence.update(newFolderModel);

    return newFolderModel;
  }
}