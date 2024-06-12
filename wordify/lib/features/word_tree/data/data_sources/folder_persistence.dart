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


  ///
  static Future<List<FolderModel>> getAll() async {
    final db = await WordifyDatabase.instance.database;
    
    final List<Map<String, dynamic>> maps = await db.query('folders');
    List<FolderModel> folders = List<FolderModel>.from(maps.map((map) => FolderModel.fromMap(map)));

    return folders;
  }
}