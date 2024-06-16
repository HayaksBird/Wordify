import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';

///A source-ambiguous storage access point interface.
abstract class WordRepository {
  Future<void> addWord(Folder folder, Word word);
  Future<void> deleteWord(Word word);
}