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

    //SAMPLE FOLDERS
    await db.execute('''
      INSERT INTO folders (name, parent_id) VALUES 
        ('German', NULL), 
        ('Idioms', 1), 
        ('Science', 1), 
        ('Computer', 3),
        ('Japanese', NULL), 
        ('Idioms', 5), 
        ('Biology', 3)
    ''');

    //SAMPLE WORDS
    await db.execute('''
    INSERT INTO words (folder_id, word, translation) VALUES
      ((SELECT id FROM folders WHERE id = 1), 'Kirche', 'Church'),
      ((SELECT id FROM folders WHERE id = 1), 'Stadt', 'City'),
      ((SELECT id FROM folders WHERE id = 1), 'Essen', 'To eat'),
      ((SELECT id FROM folders WHERE id = 1), 'Trinken', 'To drink'),
      ((SELECT id FROM folders WHERE id = 1), 'Schlafen', 'To sleep'),
      ((SELECT id FROM folders WHERE id = 1), 'Laufen', 'To run'),
      ((SELECT id FROM folders WHERE id = 1), 'Lesen', 'To read'),

      ((SELECT id FROM folders WHERE id = 2), 'Da liegt der Hund begraben', 'Thats the crux of the matter'),
      ((SELECT id FROM folders WHERE id = 2), 'Ich verstehe nur Bahnhof', 'I dont understand a thing'),
      ((SELECT id FROM folders WHERE id = 2), 'Die Katze im Sack kaufen', 'To buy a pig in a poke'),

      ((SELECT id FROM folders WHERE id = 3), 'Schwerkraft', 'Gravity'),
      ((SELECT id FROM folders WHERE id = 3), 'Evolution', 'Evolution'),
      ((SELECT id FROM folders WHERE id = 3), 'Photosynthese', 'Photosynthesis'),

      ((SELECT id FROM folders WHERE id = 4), 'Algorithmus', 'Algorithm'),
      ((SELECT id FROM folders WHERE id = 4), 'Datenbank', 'Database'),
      ((SELECT id FROM folders WHERE id = 4), 'Netzwerk', 'Network'),

      ((SELECT id FROM folders WHERE id = 5), '愛 (あい)', 'Love'),
      ((SELECT id FROM folders WHERE id = 5), '友達 (ともだち)', 'Friend'),
      ((SELECT id FROM folders WHERE id = 5), '学校 (がっこう)', 'School'),
      ((SELECT id FROM folders WHERE id = 5), '食べ物 (たべもの)', 'Food'),
      ((SELECT id FROM folders WHERE id = 5), '本 (ほん)', 'Book'),
      ((SELECT id FROM folders WHERE id = 5), '車 (くるま)', 'Car'),
      ((SELECT id FROM folders WHERE id = 5), '先生 (せんせい)', 'Teacher'),

      ((SELECT id FROM folders WHERE id = 6), '花より団子 (はなよりだんご)', 'Substance over style'),
      ((SELECT id FROM folders WHERE id = 6), '猿も木から落ちる (さるもきからおちる)', 'Even monkeys fall from trees'),
      ((SELECT id FROM folders WHERE id = 6), '案ずるより産むが易し (あんずるよりうむがやすし)', 'Giving birth to a baby is easier than worrying about it'),

      ((SELECT id FROM folders WHERE id = 7), 'Zelle', 'Cell'),
      ((SELECT id FROM folders WHERE id = 7), 'Genom', 'Genome'),
      ((SELECT id FROM folders WHERE id = 7), 'Ökosystem', 'Ecosystem');
    ''');
  }
}