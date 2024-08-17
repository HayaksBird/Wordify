///A word
abstract class WordContent {
  String get word;
  String get translation;
  String? get sentence;
}


///
class TempWordContainer {
  final String word;
  final String translation;
  final String? sentence;


  const TempWordContainer({
    required this.word,
    required this.translation,
    this.sentence
  });
}