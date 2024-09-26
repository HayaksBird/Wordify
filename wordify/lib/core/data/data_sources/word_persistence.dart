import 'package:wordify/core/data/data_sources/init_database.dart';
import 'package:wordify/core/data/model/folder_model.dart';
import 'package:wordify/core/data/model/word_model.dart';

///The persistence class for the word model.
class WordPersistence {

  ///Inserts the word into the database and returns its copy with an id present.
  static Future<WordModel> insert({
    required FolderModel folder,
    required String word,
    required String translation,
    String? sentence
  }) async {
    final db = await WordifyDatabase.instance.database;

    final int id = await db.rawInsert(
      'INSERT INTO words (folder_id, word, translation, sentence) VALUES (?, ?, ?, ?)',
      [folder.id, word, translation, sentence]
    );
      
    return WordModel(
      id: id,
      folderId: folder.id,
      word: word,
      translation: translation,
      sentence: sentence,
      folder: folder
    );
  }


  ///
  static Future<void> update(WordModel word) async {
    final db = await WordifyDatabase.instance.database;

    await db.rawUpdate(
      'UPDATE words SET folder_id = ?, word = ?, translation = ?, sentence = ?, oldest_attempt = ?, middle_attempt = ?, newest_attempt = ? WHERE id = ?',
      [word.folderId, word.word, word.translation, word.sentence, word.oldestAttempt, word.middleAttempt, word.newestAttempt, word.id]
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
  static Future<List<WordModel>> getWordsOfFolder(FolderModel folder) async {
    final db = await WordifyDatabase.instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'words',
      where: 'folder_id = ?',
      whereArgs: [folder.id],
    );
    List<WordModel> words = List<WordModel>.from(maps.map((map) => WordModel.fromMap(map, folder)));

    return words;
  }
}