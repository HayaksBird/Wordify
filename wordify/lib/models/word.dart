class Word {
  final int id;
  final String word;
  final String translation;


  const Word({
    this.id = -1,
    this.word = '',
    this.translation = ''
  });


  ///Immitate update of an object, when you actually create a new instance of it.
  Word copyWith({
    int? id,
    String? word,
    String? translation,
  }) {
    return Word(
      id: id ?? this.id,
      word: word ?? this.word,
      translation: translation ?? this.translation,
    );
  }
}