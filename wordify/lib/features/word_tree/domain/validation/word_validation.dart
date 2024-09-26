///
class WordValidation {
  String? validateWord(String word) {
    String wordTrimmed = word.trim();

    if (wordTrimmed == '') {
      return 'Provide a word';
    } else { return null; }
  }
  
  
  String? validateTranslation(String translation) {
    String translationTrimmed = translation.trim();

    if (translationTrimmed == '') {
      return 'Provide a translation';
    } else { return null; }
  }
}