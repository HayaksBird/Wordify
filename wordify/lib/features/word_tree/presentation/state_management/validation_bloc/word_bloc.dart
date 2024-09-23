import 'package:wordify/features/word_tree/domain/validation/word_validation.dart';

///Validate the update of a word.
class WordBloc {
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