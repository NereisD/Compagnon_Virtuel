import 'package:compagnon/models/todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database _database;

  NotesDatabase._init();

  //Ouvrir une connextion avec la DB
  Future<Database> get database async {
    //Si elle existe déjà on la retourne directement
    if (_database != null) return _database;

    _database = await _initDB('notes.db');
    return _database;
  }

  //Update DB
  Future<Database> _initDB(String filePath) async {
    /*prend le bon path en fonction de Android ou iOS 
    * (use Pathprovider pour choisir un path manuellement) 
    */
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    //On peut incremnter la version et ajouter un onUpgrade()
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    //Pour créer un identifiant en SQLITE
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes (
  ${TodoField.id} $idType,
  ${TodoField.isSecret} $boolType,
  ${TodoField.number} $textType,
  ${TodoField.title} $textType,
  ${TodoField.description} $textType,
  ${TodoField.createdTime} $textType
)
''');

    //On peut creer de multiples TABLEs
    /*await db.execute('''
''');*/
  }

  Future<Todo> create(Todo note) async {
    final db = await instance.database;
    //id généré par la db
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  //Lit une note du journal avec son ID
  Future<Todo> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: TodoField.values,
      /* Pour chaque '?' on associe un paramètre afin d'éviter les
      * injections SQL
      */
      where: '${TodoField.id} = ?',
      whereArgs: [id],
    );

    //Si la requête est un succès
    if (maps.isNotEmpty) {
      /* On peut recuperer seulement le 1er item car on 
      * ne retourne qu'une seule note
      */
      return Todo.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  //Pour lire toutes les notes du journal
  Future<List<Todo>> readAllNotes() async {
    final db = await instance.database;

    const orderBy = '${TodoField.createdTime} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Todo.fromJson(json)).toList();
  }

  //Modifie une note en fonction de son ID
  Future<int> update(Todo note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${TodoField.id} = ?',
      whereArgs: [note.id],
    );
  }

  //Supprime une note en fonction de son ID
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${TodoField.id} = ?',
      whereArgs: [id],
    );
  }

  //Close DB
  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
