///A word
class Word {
  final String word;
  final String translation;
  final String? sentence;


  const Word({
    required this.word,
    required this.translation,
    this.sentence
  });
}