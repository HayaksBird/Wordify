class Word {
  final String word;
  final String translation;


  const Word({
    this.word = '',
    this.translation = ''
  });


  ///Immitate update of an object, when you actually create a new instance of it.
  Word copyWith({
    String? word,
    String? translation,
  }) {
    return Word(
      word: word ?? this.word,
      translation: translation ?? this.translation,
    );
  }
}