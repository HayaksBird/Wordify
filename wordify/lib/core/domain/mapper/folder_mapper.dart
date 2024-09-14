import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/domain/entities/folder_words_container.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';

class FolderMapper {

  ///
  static FolderModel toFolderModel(FolderContent folder) {
    return folder as FolderModel;
  }


  ///
  static FolderWordsContainer toFolderWordsContainer(FolderWords expandedFolder) {
    return expandedFolder as FolderWordsContainer;
  }
}