import 'package:wordify/features/word_tree/domain/validation/word_validation.dart';

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