import 'package:wordify/features/word_tree/domain/entities/word.dart';


///Represents a folder.
///
///Not mutable (const) -> a new intance will be requested, when a word in the folder
///is created/updated/deleted.
class Folder {
  final String name;
  final List<Word> words;


  const Folder({
    required this.name,
    this.words = const []
  });


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Folder &&
        other.name == name;
  }


  @override
  int get hashCode => name.hashCode;  
}