import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/validation/folder_validation.dart';
import 'package:wordify/features/word_tree/domain/validation/word_validation.dart';

///Validate the update of a folder.
class FolderValidationBloc {
  static final FolderValidationBloc _instance = FolderValidationBloc._internal();
  final FolderValidation _folderValidator = FolderValidation();


  factory FolderValidationBloc() {
    return _instance;
  }


  FolderValidationBloc._internal();


  ///
  String? validateFolderName(String name, [String? oldName]) {
    return _folderValidator.validateName(
      name: name,
      oldName: oldName
    );
  }


  String? validateChooseFolder(Folder? folder) {
    return _folderValidator.validateChooseFolder(folder);
  }
}



///Validate the update of a word.
class WordValidationBloc {
  static final WordValidationBloc _instance = WordValidationBloc._internal();
  final WordValidation _wordValidator = WordValidation();


  factory WordValidationBloc() {
    return _instance;
  }


  WordValidationBloc._internal();


  ///
  String? validateWordWord(String word) {
    return _wordValidator.validateWord(word);
  }


  ///
  String? validateWordTranslation(String translation) {
    return _wordValidator.validateTranslation(translation);
  }
}