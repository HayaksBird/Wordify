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