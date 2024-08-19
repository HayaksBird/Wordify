///A word interface that will be used to reference an actual word object
///received from the data layer.
abstract class WordContent {
  String get word;
  String get translation;
  String? get sentence;
}



///A DTO object for the word.
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