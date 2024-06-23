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
      version: 1,
      onCreate: _createDatabase,
    );
  }


  ///Create the interior of the database if it does not exist.
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');
    
    await db.execute('''
      CREATE TABLE words (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folder_id INTEGER NOT NULL,
        word TEXT NOT NULL UNIQUE,
        translation TEXT NOT NULL,
        FOREIGN KEY (folder_id) REFERENCES folders (id)
      )
    ''');

    // Insert sample data into folders table
    await db.execute('''
      INSERT INTO folders (name) VALUES ('German'), ('Turkish'), ('Japanese'), ('French')
    ''');

    // Insert sample data into words table
    await db.execute('''
      INSERT INTO words (folder_id, word, translation) VALUES
        ((SELECT id FROM folders WHERE name = 'German'), 'Kirche', 'Church'),
        ((SELECT id FROM folders WHERE name = 'German'), 'Stadt', 'City'),
        ((SELECT id FROM folders WHERE name = 'German'), 'Essen', 'To eat'),
        ((SELECT id FROM folders WHERE name = 'German'), 'Trinken', 'To drink'),
        ((SELECT id FROM folders WHERE name = 'German'), 'Schlafen', 'To sleep'),
        ((SELECT id FROM folders WHERE name = 'German'), 'Laufen', 'To run'),
        ((SELECT id FROM folders WHERE name = 'German'), 'Lesen', 'To read'),
        ((SELECT id FROM folders WHERE name = 'Turkish'), 'Almak', 'To Buy'),
        ((SELECT id FROM folders WHERE name = 'Turkish'), 'Adam', 'Man'),
        ((SELECT id FROM folders WHERE name = 'Turkish'), 'Kitab', 'Book'),
        ((SELECT id FROM folders WHERE name = 'Turkish'), 'Yemek', 'Food'),
        ((SELECT id FROM folders WHERE name = 'Turkish'), 'Su', 'Water'),
        ((SELECT id FROM folders WHERE name = 'Turkish'), 'Uçmak', 'To Fly'),
        ((SELECT id FROM folders WHERE name = 'Turkish'), 'Yazmak', 'To write'),
        ((SELECT id FROM folders WHERE name = 'Japanese'), '愛 (あい)', 'Love'),
        ((SELECT id FROM folders WHERE name = 'Japanese'), '友達 (ともだち)', 'Friend'),
        ((SELECT id FROM folders WHERE name = 'Japanese'), '学校 (がっこう)', 'School'),
        ((SELECT id FROM folders WHERE name = 'Japanese'), '食べ物 (たべもの)', 'Food'),
        ((SELECT id FROM folders WHERE name = 'Japanese'), '本 (ほん)', 'Book'),
        ((SELECT id FROM folders WHERE name = 'Japanese'), '車 (くるま)', 'Car'),
        ((SELECT id FROM folders WHERE name = 'Japanese'), '先生 (せんせい)', 'Teacher'),
        ((SELECT id FROM folders WHERE name = 'French'), 'bonjour', 'hello'),
        ((SELECT id FROM folders WHERE name = 'French'), 'merci', 'thank you'),
        ((SELECT id FROM folders WHERE name = 'French'), 'au revoir', 'goodbye'),
        ((SELECT id FROM folders WHERE name = 'French'), 'excusez-moi', 'excuse me'),
        ((SELECT id FROM folders WHERE name = 'French'), 'oui', 'yes'),
        ((SELECT id FROM folders WHERE name = 'French'), 'non', 'no'),
        ((SELECT id FROM folders WHERE name = 'French'), 'bienvenue', 'welcome'),
        ((SELECT id FROM folders WHERE name = 'French'), 'pardon', 'sorry');
    ''');
  }
}