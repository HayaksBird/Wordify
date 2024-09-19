import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/domain/entities/folder.dart';

class FolderMapper {

  ///
  static FolderModel toFolderModel(FolderContent folder) {
    return folder as FolderModel;
  }
}