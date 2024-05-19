import 'package:wordify/features/word_tree/domain/entities/word.dart';

class WordModel extends Word {
  const WordModel({
    super.id,
    super.word,
    super.translation
  });


  ///
  WordModel.fromWord(Word word)
      : super(id: word.id, word: word.word, translation: word.translation);


  // Create a Word from a Map
  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map['id'] as int,
      word: map['word'] as String,
      translation: map['translation'] as String,
    );
  }


  ///Immitate update of an object, when you actually create a new instance of it.
  WordModel copyWith({
    int? id,
    String? word,
    String? translation,
  }) {
    return WordModel(
      id: id ?? this.id,
      word: word ?? this.word,
      translation: translation ?? this.translation,
    );
  }
}