import 'package:wordify/core/data/data_sources/init_database.dart';
import 'package:wordify/core/data/model/folder_model.dart';

///
class FolderPersistence {
  ///
  static Future<FolderModel> insert({
    int? parentId,
    required String name
  }) async {
    final db = await WordifyDatabase.instance.database;

    final int id = await db.rawInsert(
      'INSERT INTO folders (name, parent_id) VALUES (?, ?)',
      [name, parentId]
    );

    return FolderModel(
      id: id,
      parentId: parentId,
      name: name
    );
  }


  ///Delete a folder in a single transaction, in order
  ///to not delete the folder partially in a case of program error.
  static Future<void> delete(FolderModel folder) async {
    final db = await WordifyDatabase.instance.database;

    await db.transaction((txn) async {
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
  static Future<List<FolderModel>> getRootFolders() async {
    final db = await WordifyDatabase.instance.database;

    // Corrected query to select folders where parent_id is NULL and name is not an empty string
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM folders WHERE parent_id IS NULL AND name != ""'
    );

    List<FolderModel> folders = List<FolderModel>.from(maps.map((map) => FolderModel.fromMap(map)));

    return folders;
  }


  ///
  static Future<List<FolderModel>> getFolders(int parentId) async {
    final db = await WordifyDatabase.instance.database;

    //Query to select folders with the given parent_id
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM folders WHERE parent_id = ?',
      [parentId]
    );

    List<FolderModel> folders = List<FolderModel>.from(maps.map((map) => FolderModel.fromMap(map)));

    return folders;
  }


  ///
  static Future<FolderModel> getBufferFolder() async {
    final db = await WordifyDatabase.instance.database;

    // Query to select the folder with parent_id as NULL and name as an empty string
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM folders WHERE parent_id IS NULL AND name = ""'
    );

    if (maps.isNotEmpty) {
      return FolderModel.fromMap(maps.first);
    } else {
      throw Exception('Buffer folder not found');
    }
  }
}