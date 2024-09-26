import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/domain/entities/folder.dart';

///Map between the interface references for a folder model with the folder model.
class FolderMapper {

  ///
  static FolderModel toFolderModel(FolderContent folder) {
    return folder as FolderModel;
  }
}