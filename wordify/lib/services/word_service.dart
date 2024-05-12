import 'package:wordify/models/data_layer.dart';
import 'package:wordify/services/init_database.dart';

class WordService {
  ///
  static Future<Word> save(Word word) async {
    if (word.id == -1) {  //insert
      return await insert(word);
    } else {
      await update(word);
      return word;
    }
  }


  ///Insets the word into the database and returns its copy with an id present.
  static Future<Word> insert(Word word) async {
    final db = await WordifyDatabase.instance.database;
    final int id = await db.rawInsert(
      'INSERT INTO words (word, translation) VALUES (?, ?)',
      [word.word, word.translation]
    );

    return word.copyWith(id: id);
  }


  ///
  static Future<void> update(Word word) async {
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
}