///
class WordValidation {
  String? validateWord(String word) {
    if (word == '') {
      return 'Provide a word';
    } else { return null; }
  }
  
  
  String? validateTranslation(String translation) {
    if (translation == '') {
      return 'Provide a translation';
    } else { return null; }
  }
}