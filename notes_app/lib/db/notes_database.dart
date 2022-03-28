import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes_app/model/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  //Constructeur
  NotesDatabase._init();

  //To Open a connection
  Future<Database> get database async {
    //Si la database existe déjà, on la renvoie
    if (_database != null) return _database!;
    //Sinon on l'initialise dans le fichier notes.db
    _database = await _initDB('notes.db');
    return _database!;
  }

  //Méthode pour initialiser la DB
  Future<Database> _initDB(String filePath) async {
    //Différentes locations sur Android et IOS
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
    //Lorsqu'on veut upgrade la DB en une nouvelle version
    //return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: );
  }

/* Cette méthode s'exécute uniquement lorsque le fichier notes.db est 
*  inexistant et qu'il faut l'initialiser.
*/
  Future _createDB(Database db, int version) async {
    //Pour créer un identifiant
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes( 
  ${NoteFields.id} $idType,
  ${NoteFields.isImportant} $boolType,
  ${NoteFields.number} $integerType,
  ${NoteFields.title} $textType,
  ${NoteFields.description} $textType,
  ${NoteFields.time} $textType
)
''');
//On peut faire plusieurs await db pour créer d'autres tables
  }

  //CRUD : créer
  Future<Note> create(Note note) async {
    final db = await instance.database;
    //On définie les data qu'on doit convernir en Map avec toJson()
    final id = await db.insert(tableNotes, note.toJson());
    //On créer une copie en modifiant uniquement l'id
    return note.copy(id: id);
  }

  //CRUD : lire uen note
  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
      /*whereArgs: [id, etc., etc.], pour chaque '?'
      * Permet d'éviter les injections SQL
      */
    );
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  //CRUD : lire toutes les notes
  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${NoteFields.time} ASC'; //ASC = ascending order
    //En paramètres de la query : where, orderBy, having, limit etc.
    final result = await db.query(tableNotes, orderBy: orderBy);

    /*On peut aussi écrire en brut :
    final result =
        await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');*/

    return result.map((json) => Note.fromJson(json)).toList();
  }

  //CRUD : update
  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  //CRUD : delete
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  //Méthode pour fermer la DB
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
