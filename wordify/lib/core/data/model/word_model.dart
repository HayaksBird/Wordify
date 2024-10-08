import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/domain/entities/word.dart';

///The exact model of a word from the database.
///Implements multiple interfaces from different features to
///segregate the view for them.
class WordModel implements WordContent, WordContentStats {
  final int id;
  final int folderId;
  @override
  final String word;
  @override
  final String translation;
  @override
  final String? sentence;
  @override
  final int oldestAttempt, middleAttempt, newestAttempt;
  @override
  final FolderModel folder;


  const WordModel({
    required this.id,
    required this.folderId,
    required this.word,
    required this.translation,
    this.sentence,
    this.oldestAttempt = 1,
    this.middleAttempt = 1,
    this.newestAttempt = 1,
    required this.folder
  });


  // Create a Word from a Map
  factory WordModel.fromMap(Map<String, dynamic> map, FolderModel folder) {
    return WordModel(
      id: map['id'] as int,
      folderId: map['folder_id'] as int,
      word: map['word'] as String,
      translation: map['translation'] as String,
      sentence: map['sentence'] as String?,
      oldestAttempt: map['oldest_attempt'] as int,
      middleAttempt: map['middle_attempt'] as int,
      newestAttempt: map['newest_attempt'] as int,
      folder: folder
    );
  }


  ///Immitate update of an object, when you actually create a new instance of it.
  WordModel copyWith({
    int? id,
    int? folderId,
    String? word,
    String? translation,
    String? sentence,
    int? oldestAttempt,
    int? middleAttempt,
    int? newestAttempt,
    FolderModel? folder
  }) {
    return WordModel(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      sentence: sentence ?? this.sentence,
      oldestAttempt: oldestAttempt ?? this.oldestAttempt,
      middleAttempt: middleAttempt ?? this.middleAttempt,
      newestAttempt: newestAttempt ?? this.newestAttempt,
      folder: folder ?? this.folder
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