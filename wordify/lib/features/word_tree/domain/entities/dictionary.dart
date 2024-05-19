import 'package:wordify/features/word_tree/domain/entities/word.dart';

///Contains all words
class Dictionary {
  final List<Word> words;


  ///The List is immutable, so it won't be accidentally updated.
  const Dictionary({this.words = const []});
}