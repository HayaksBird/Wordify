import 'package:wordify/features/word_tree/domain/entities/word.dart';

///Represents the database table row as an object.
///Used for ORM
class WordModel extends Word {
  final int id;
  

  const WordModel({
    required this.id,
    super.word,
    super.translation
  });


  ///
  WordModel.fromWord(Word word, {this.id = -1})
      : super(word: word.word, translation: word.translation);


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