import 'package:wordify/features/word_tree/domain/entities/word.dart';

///Will be used for the folders in view list.
///There is no need for the them to have a list of words param.
class Folder {
  final String name;
  

  const Folder({
    required this.name
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


///The folder that has been accessed (open).
class ExpandedFolder extends Folder {
  final List<Word> words;


  const ExpandedFolder({
    required super.name,
    this.words = const []
  });
}