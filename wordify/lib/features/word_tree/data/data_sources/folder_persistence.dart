import 'package:wordify/features/word_tree/data/data_sources/init_database.dart';
import 'package:wordify/features/word_tree/data/model/folder_model.dart';

///
class FolderPersistence {
  ///
  static Future<FolderModel> insert(FolderModel folder) async {
    final db = await WordifyDatabase.instance.database;

    final int id = await db.rawInsert(
      'INSERT INTO folders (name) VALUES (?)',
      [folder.name]
    );

    return folder.copyWith(id: id);
  }


  ///Delete a folder in a single transaction, in order
  ///to not delete the folder partially in a case of program error.
  static Future<void> delete(FolderModel folder) async {
    final db = await WordifyDatabase.instance.database;

    await db.transaction((txn) async {
      // Delete all words associated with the folder
      await txn.rawDelete(
        'DELETE FROM words WHERE folder_id = ?',
        [folder.id],
      );
      
      // Delete the folder itself
      await txn.rawDelete(
        'DELETE FROM folders WHERE id = ?',
        [folder.id],
      );
    });
  }


  ///
  static Future<void> update(FolderModel folder) async {
    final db = await WordifyDatabase.instance.database;

    await db.rawUpdate(
      'UPDATE folders SET name = ? WHERE id = ?',
      [folder.name, folder.id],
    );
  }


  ///
  static Future<List<FolderModel>> getAll() async {
    final db = await WordifyDatabase.instance.database;
    
    final List<Map<String, dynamic>> maps = await db.query('folders');
    List<FolderModel> folders = List<FolderModel>.from(maps.map((map) => FolderModel.fromMap(map)));

    return folders;
  }
}