import 'package:wordify/features/word_tree/domain/entities/word.dart';

///Represents the database table row as an object.
///Used for ORM
class WordModel extends Word {
  final int id;
  final int folderId;
  

  const WordModel({
    required this.id,
    required this.folderId,
    required super.word,
    required super.translation,
    required super.sentence
  });


  ///
  WordModel.fromWord(Word word, {this.id = -1, this.folderId = -1})
      : super(word: word.word,
              translation: word.translation,
              sentence: word.sentence
        );


  // Create a Word from a Map
  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map['id'] as int,
      folderId: map['folder_id'] as int,
      word: map['word'] as String,
      translation: map['translation'] as String,
      sentence: map['sentence'] as String?
    );
  }


  ///Immitate update of an object, when you actually create a new instance of it.
  WordModel copyWith({
    int? id,
    int? folderId,
    String? word,
    String? translation,
    String? sentence
  }) {
    return WordModel(
      id: id ?? this.id,
      folderId: this.folderId,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      sentence: sentence ?? this.sentence
    );
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    if (other is! WordModel) return false;
    return id == other.id;
  }
  

  @override
  int get hashCode => id.hashCode;
}