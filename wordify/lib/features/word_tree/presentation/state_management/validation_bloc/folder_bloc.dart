import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_service.dart';
import 'package:wordify/features/word_tree/domain/validation/folder_validation.dart';

///Validate the update of a folder.
class FolderBloc {
  final DictionaryService _dictionaryService = DictionaryService();
  final FolderValidation _folderValidator = FolderValidation();


  ///
  String? validateInsertFolderName(String newName, FolderContent? parentFolder) {
    return _folderValidator.validateName(
      newName,
      parentFolder != null ?
      _dictionaryService.foldersInViewState.getChildren(parentFolder) :
      _dictionaryService.foldersInViewState.getRootFolders()
    );
  }


  ///
  String? validateUpdateFolderName(String newName, FolderContent? parentFolder, String oldName) {
    return _folderValidator.validateName(
      newName,
      parentFolder != null ?
      _dictionaryService.foldersInViewState.getChildren(parentFolder) :
      _dictionaryService.foldersInViewState.getRootFolders(),
      oldName
    );
  }


  String? validateChooseFolder(FolderContent? folder) {
    return _folderValidator.validateChooseFolder(folder);
  }
}