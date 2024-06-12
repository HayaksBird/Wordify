import 'package:wordify/features/word_tree/domain/entities/word.dart';

class Folder {
  final String name;
  final List<Word> words;


  const Folder({
    required this.name,
    this.words = const [],
  });
}