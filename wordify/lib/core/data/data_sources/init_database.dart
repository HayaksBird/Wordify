import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

///Handles the initialization and connection to the database
class WordifyDatabase {
  static final WordifyDatabase instance = WordifyDatabase._internal();  //Create a single instance of the class (singleton)
  static Database? _database; //Single instance of the database


  WordifyDatabase._internal();


  ///If the Database object is null, then create it by establishing the 
  ///connection to the sqlite server.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }


  ///Opens an existing database and returns a reference to it.
  ///If the database does not exist, it will be created first.
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();  //Get the path of the place where the sqlite databases are stored.
    final path = join(databasePath, 'wordify.db');

    return await openDatabase(
      path,
      version: 2, //indicate the current version to trigger the onUpgrade
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }


  ///
  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (newVersion >= 2) {  //For version 2 and above
      await db.execute('''
        ALTER TABLE words ADD COLUMN oldest_attempt INTEGER DEFAULT 1;
      ''');

      await db.execute('''
        ALTER TABLE words ADD COLUMN middle_attempt INTEGER DEFAULT 1;
      ''');

      await db.execute('''
        ALTER TABLE words ADD COLUMN newest_attempt INTEGER DEFAULT 1;
      ''');
    }
  }


  ///Create the interior of the database if it does not exist.
  Future<void> _createDatabase(Database db, int version) async {
    //CREATE FOLDERS TABLE
    await db.execute('''
      CREATE TABLE folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        parent_id INTEGER
      )
    ''');

    //CREATE WORDS TABLE
    await db.execute('''
      CREATE TABLE words (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folder_id INTEGER NOT NULL,
        word TEXT NOT NULL,
        translation TEXT NOT NULL,
        sentence TEXT,
        FOREIGN KEY (folder_id) REFERENCES folders (id)
      )
    ''');

    //DELETE WORDS OF A FOLDER WHICH IS DELETED
    await db.execute('''
      CREATE TRIGGER delete_words_when_folder_deleted
      AFTER DELETE ON folders
      FOR EACH ROW
      BEGIN
          DELETE FROM words WHERE folder_id = OLD.id;
      END;
    ''');

    //INSERT A BUFFER FOLDER
    await db.execute('''
      INSERT INTO folders (name, parent_id) VALUES
        ('', NULL)
    ''');

    _upgradeDatabase(db, 1, version);
  }
}