import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_manager.dart';
import 'package:wordify/features/word_tree/domain/validation/folder_validation.dart';
import 'package:wordify/features/word_tree/domain/validation/word_validation.dart';

final DictionaryManager _dictionaryManager = DictionaryManager();




class ValidationBloc {
  static final ValidationBloc _instance = ValidationBloc._internal();
  late final FolderValidationBloc folder;
  late final WordValidationBloc word;


  factory ValidationBloc() {
    return _instance;
  }


  ValidationBloc._internal() {
    folder = FolderValidationBloc();
    word = WordValidationBloc();
  }
}



///Validate the update of a folder.
class FolderValidationBloc {
  final FolderValidation _folderValidator = FolderValidation();


  ///
  String? validateInsertFolderName(String newName, Folder? parentFolder) {
    if (parentFolder != null) {
      return _folderValidator.validateName(newName, _dictionaryManager.state.getChildren(parentFolder));
    }
    
    return null;
  }


  ///
  String? validateUpdateFolderName(String newName, Folder folder, String oldName) {
    return _folderValidator.validateName(newName, _dictionaryManager.state.getSiblingsInclusive(folder), oldName);
  }


  String? validateChooseFolder(Folder? folder) {
    return _folderValidator.validateChooseFolder(folder);
  }
}



///Validate the update of a word.
class WordValidationBloc {
  final WordValidation _wordValidator = WordValidation();


  ///
  String? validateWordWord(String word) {
    return _wordValidator.validateWord(word);
  }


  ///
  String? validateWordTranslation(String translation) {
    return _wordValidator.validateTranslation(translation);
  }
}