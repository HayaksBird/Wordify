import 'package:wordify/core/domain/entities/folder.dart';

///The exact model of a folder from the database.
class FolderModel implements FolderContent {
  final int id;
  final int? parentId;
  @override
  final String name;


  const FolderModel({
    required this.id,
    required this.parentId,
    required this.name
  });


  factory FolderModel.fromMap(Map<String, dynamic> map) {
    return FolderModel(
      id: map['id'] as int,
      parentId: map['parent_id'] as int?,
      name: map['name'] as String,
    );
  }


  ///Immitate update of an object, when you actually create a new instance of it.
  FolderModel copyWith({
    int? id,
    int? parentId,
    String? name
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