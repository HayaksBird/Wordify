import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';

class FolderModel extends Folder {
  final int id;
  final int? parentId;

  const FolderModel({
    required this.id,
    required this.parentId,
    required super.name
  });


  factory FolderModel.fromMap(Map<String, dynamic> map) {
    return FolderModel(
      id: map['id'] as int,
      parentId: map['parent_id'] as int?,
      name: map['name'] as String,
    );
  }


  FolderModel.fromFolder(Folder folder, {this.id = -1, this.parentId})
      : super(name: folder.name);


  ///Immitate update of an object, when you actually create a new instance of it.
  FolderModel copyWith({
    int? id,
    int? parentId,
    String? name,
    List<Word>? words,
  }) {
    return FolderModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name
    );
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    if (other is! FolderModel) return false;
    return id == other.id;
  }


  @override
  int get hashCode => id.hashCode;
}