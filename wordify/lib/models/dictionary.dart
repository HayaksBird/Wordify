import 'package:wordify/models/word.dart';

///Contains all words
class Dictionary {
  final List<Word> words;


  ///The List is immutable, so it won't be accidentally updated.
  const Dictionary({this.words = const []});
}