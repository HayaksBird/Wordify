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
    final path = join(databasePath, 'wordify-test.db');

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

      //ADD NEW CODE HERE
      await db.execute('''
        UPDATE words SET oldest_attempt = 3, middle_attempt = 1, newest_attempt = 1 WHERE word = 'Kirche';
      ''');

      await db.execute('''
        UPDATE words SET oldest_attempt = 2, middle_attempt = 2, newest_attempt = 1 WHERE word = 'Stadt';
      ''');

      await db.execute('''
        UPDATE words SET oldest_attempt = 1, middle_attempt = 2, newest_attempt = 1 WHERE word = 'Essen';
      ''');

      await db.execute('''
        UPDATE words SET oldest_attempt = 1, middle_attempt = 1, newest_attempt = 2 WHERE word = 'Trinken';
      ''');

      await db.execute('''
        UPDATE words SET oldest_attempt = 1, middle_attempt = 1, newest_attempt = 1 WHERE word = 'Schlafen';
      ''');

      await db.execute('''
        UPDATE words SET oldest_attempt = 2, middle_attempt = 1, newest_attempt = 3 WHERE word = 'Laufen';
      ''');

      await db.execute('''
        UPDATE words SET oldest_attempt = 2, middle_attempt = 2, newest_attempt = 2 WHERE word = 'Lesen';
      ''');

      // Insert new words
      await db.execute('''
        INSERT INTO words (folder_id, word, translation, sentence, oldest_attempt, middle_attempt, newest_attempt) VALUES
          ((SELECT id FROM folders WHERE id = 2), 'Spielen', 'To play', 'Ich spiele gern.', 2, 1, 3),
          ((SELECT id FROM folders WHERE id = 2), 'Mutter', 'Mother', 'Das ist meine Mutter.', 2, 2, 3),
          ((SELECT id FROM folders WHERE id = 2), 'Vater', 'Father', 'Das ist mein Vater.', 1, 3, 3),
          ((SELECT id FROM folders WHERE id = 2), 'Hallo', 'Hello', 'Hallo, wie geht es dir?', 3, 3, 3);
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
        ('', NULL),
        ('German', NULL), 
        ('Idioms', 2), 
        ('Science', 2), 
        ('Computer', 4),
        ('Japanese', NULL), 
        ('Idioms', 6), 
        ('Biology', 4)
    ''');

    //SAMPLE WORDS
    await db.execute('''
    INSERT INTO words (folder_id, word, translation, sentence) VALUES
      ((SELECT id FROM folders WHERE id = 2), 'Kirche', 'Church', 'Die Kirche ist sehr alt.'),
      ((SELECT id FROM folders WHERE id = 2), 'Stadt', 'City', 'Die Stadt ist sehr groß.'),
      ((SELECT id FROM folders WHERE id = 2), 'Essen', 'To eat', 'Wir gehen jetzt essen.'),
      ((SELECT id FROM folders WHERE id = 2), 'Trinken', 'To drink', 'Ich möchte etwas trinken.'),
      ((SELECT id FROM folders WHERE id = 2), 'Schlafen', 'To sleep', 'Ich gehe um 10 Uhr schlafen.'),
      ((SELECT id FROM folders WHERE id = 2), 'Laufen', 'To run', 'Ich laufe jeden Morgen.'),
      ((SELECT id FROM folders WHERE id = 2), 'Lesen', 'To read', 'Ich lese gerne Bücher.'),
      ((SELECT id FROM folders WHERE id = 3), 'Da liegt der Hund begraben', 'Thats the crux of the matter', 'Jetzt weiß ich, wo der Hund begraben liegt.'),
      ((SELECT id FROM folders WHERE id = 3), 'Ich verstehe nur Bahnhof', 'I dont understand a thing', 'Bei dieser Erklärung verstehe ich nur Bahnhof.'),
      ((SELECT id FROM folders WHERE id = 3), 'Die Katze im Sack kaufen', 'To buy a pig in a poke', 'Du solltest die Katze nicht im Sack kaufen.'),
      ((SELECT id FROM folders WHERE id = 4), 'Schwerkraft', 'Gravity', 'Die Schwerkraft zieht uns zur Erde.'),
      ((SELECT id FROM folders WHERE id = 4), 'Evolution', 'Evolution', 'Die Evolution erklärt die Vielfalt des Lebens.'),
      ((SELECT id FROM folders WHERE id = 4), 'Photosynthese', 'Photosynthesis', 'Pflanzen betreiben Photosynthese zur Energiegewinnung.'),
      ((SELECT id FROM folders WHERE id = 5), 'Algorithmus', 'Algorithm', 'Ein Algorithmus löst ein Problem Schritt für Schritt.'),
      ((SELECT id FROM folders WHERE id = 5), 'Datenbank', 'Database', 'Die Daten werden in einer Datenbank gespeichert.'),
      ((SELECT id FROM folders WHERE id = 5), 'Netzwerk', 'Network', 'Ein Netzwerk verbindet mehrere Computer.'),
      ((SELECT id FROM folders WHERE id = 6), '愛 (あい)', 'Love', '愛は世界を動かす力です。'),
      ((SELECT id FROM folders WHERE id = 6), '友達 (ともだち)', 'Friend', '友達と一緒に遊びました。'),
      ((SELECT id FROM folders WHERE id = 6), '学校 (がっこう)', 'School', '学校へ行く時間です。'),
      ((SELECT id FROM folders WHERE id = 6), '食べ物 (たべもの)', 'Food', 'おいしい食べ物がたくさんあります。'),
      ((SELECT id FROM folders WHERE id = 6), '本 (ほん)', 'Book', '面白い本を読んでいます。'),
      ((SELECT id FROM folders WHERE id = 6), '車 (くるま)', 'Car', '新しい車を買いました。'),
      ((SELECT id FROM folders WHERE id = 6), '先生 (せんせい)', 'Teacher', '先生はとても親切です。'),
      ((SELECT id FROM folders WHERE id = 7), '花より団子 (はなよりだんご)', 'Substance over style', '彼は花より団子だ。'),
      ((SELECT id FROM folders WHERE id = 7), '猿も木から落ちる (さるもきからおちる)', 'Even monkeys fall from trees', '猿も木から落ちることがある。'),
      ((SELECT id FROM folders WHERE id = 7), '案ずるより産むが易し (あんずるよりうむがやすし)', 'Giving birth to a baby is easier than worrying about it', '案ずるより産むが易しということわざがあります。'),
      ((SELECT id FROM folders WHERE id = 8), 'Zelle', 'Cell', 'Eine Zelle ist die kleinste Einheit des Lebens.'),
      ((SELECT id FROM folders WHERE id = 8), 'Genom', 'Genome', 'Das Genom enthält alle genetischen Informationen.'),
      ((SELECT id FROM folders WHERE id = 8), 'Ökosystem', 'Ecosystem', 'Ein Ökosystem besteht aus vielen verschiedenen Organismen.')
    ''');

    _upgradeDatabase(db, 1, version);
  }
}