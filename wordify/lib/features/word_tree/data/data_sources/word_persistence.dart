import 'package:wordify/features/word_tree/data/model/word_model.dart';
import 'package:wordify/features/word_tree/data/data_sources/init_database.dart';

class WordPersistence {
  ///Insets the word into the database and returns its copy with an id present.
  static Future<WordModel> insert(WordModel word) async {
    final db = await WordifyDatabase.instance.database;
    final int id = await db.rawInsert(
      'INSERT INTO words (word, translation) VALUES (?, ?)',
      [word.word, word.translation]
    );

    return word.copyWith(id: id);
  }


  ///
  static Future<void> update(WordModel word) async {
    final db = await WordifyDatabase.instance.database;
    await db.rawUpdate(
      'UPDATE words SET word = ?, translation = ? WHERE id = ?',
      [word.word, word.translation, word.id]
    );
  }


  ///
  static Future<void> delete(int id) async {
    final db = await WordifyDatabase.instance.database;
    await db.rawDelete(
      'DELETE FROM words WHERE id = ?',
      [id]
    );
  }


  ///
  static Future<List<WordModel>> getAll() async {
    final db = await WordifyDatabase.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('words');
    List<WordModel> words = List<WordModel>.from(maps.map((map) => WordModel.fromMap(map)));

    return words;
  }
}