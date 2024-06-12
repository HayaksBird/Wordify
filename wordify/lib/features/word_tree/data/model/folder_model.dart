import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';

class FolderModel extends Folder {
  final int id;


  const FolderModel({
    required this.id,
    required super.name,
    super.words
  });


  factory FolderModel.fromMap(Map<String, dynamic> map) {
    return FolderModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }


  FolderModel.fromFolder(Folder folder, {this.id = -1})
      : super(name: folder.name, words: folder.words);


  ///Immitate update of an object, when you actually create a new instance of it.
  FolderModel copyWith({
    int? id,
    String? name,
    List<Word>? words,
  }) {
    return FolderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      words: words ?? this.words,
    );
  }
}