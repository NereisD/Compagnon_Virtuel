import 'package:compagnon/constants.dart';
import 'package:compagnon/models/Message.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MessageDatabase {
  static final MessageDatabase instance = MessageDatabase._init();

  static Database _database;

  MessageDatabase._init();

  //Ouvrir une connextion avec la DB
  Future<Database> get database async {
    //Si elle existe déjà on la retourne directement
    if (_database != null) return _database;

    _database = await _initDB('messages.db');
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
CREATE TABLE $tableMessages (
  ${MessageField.id} $idType,
  ${MessageField.text} $textType,
  ${MessageField.date} $textType,
  ${MessageField.isSentByMe} $boolType,
  ${MessageField.isLiked} $boolType,
  ${MessageField.isSecret} $boolType
)
''');

    //On peut creer de multiples TABLEs
    /*await db.execute('''
''');*/
  }

  Future<Message> create(Message message) async {
    //print("Create message");
    //message.displayContent();
    final db = await instance.database;
    //id généré par la db
    final id = await db.insert(tableMessages, message.toJson());
    print("-- Message créé --");
    //loadingMessage = false; //test
    return message.copy(id: id);
  }

  //Lit un message avec son ID
  Future<Message> readMessage(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableMessages,
      columns: MessageField.values,
      /* Pour chaque '?' on associe un paramètre afin d'éviter les
      * injections SQL
      */
      where: '${MessageField.id} = ?',
      whereArgs: [id],
    );

    //Si la requête est un succès
    if (maps.isNotEmpty) {
      /* On peut recuperer seulement le 1er item car on 
      * ne retourne qu'un seul message
      */
      return Message.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<List<Message>> readAllMessages() async {
    final db = await instance.database;

    const orderBy = '${MessageField.date} ASC';
    final result = await db.query(tableMessages, orderBy: orderBy);

    return result.map((json) => Message.fromJson(json)).toList();
  }

  //Pour lire les messages non secrets
  Future<List<Message>> readAllMessagesNotSecret() async {
    final db = await instance.database;

    const orderBy = '${MessageField.date} ASC';
    final result = await db.query(
      tableMessages,
      orderBy: orderBy,
      where: '${MessageField.isSecret} == 0',
    );

    return result.map((json) => Message.fromJson(json)).toList();
  }

  //Modifie un message
  Future<int> update(Message message) async {
    final db = await instance.database;

    return db.update(
      tableMessages,
      message.toJson(),
      where: '${MessageField.id} = ?',
      whereArgs: [message.id],
    );
  }

  //Supprime un message en fonction de son ID
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableMessages,
      where: '${MessageField.id} = ?',
      whereArgs: [id],
    );
  }

  //Close DB
  Future close() async {
    final db = await instance.database;

    db.close();
  }

  /*
  MessageDatabase._();

  static final MessageDatabase instance = MessageDatabase._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'message_Database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE message(id INTEGER PRIMARY KEY,text TEXT,date TEXT,isSentByMe INTEGER,isLiked INTEGER,isSecret INTEGER)");
      },
      version: 1,
    );
  }

  void insertMessage(Message message) async {
    final Database db = await database;

    await db.insert('message', message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void updateMessage(Message message) async {
    final Database db = await database;
    await db.update("message", message.toMap(),
        where: "title = ?", whereArgs: [message.id]);
  }

  void deleteMessage(int id) async {
    final Database db = await database;
    db.delete("message", where: "title = ?", whereArgs: [id]);
  }

  Future<List<Message>> messages() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('message');
    List<Message> messages = List.generate(maps.length, (i) {
      return Message.fromMap(maps[i]);
    });

    if (messages.isEmpty) {
      for (Message message in defaultMessages) {
        insertMessage(message);
      }
      messages = defaultMessages;
    }

    return messages;
  }

  final List<Message> defaultMessages = [
    Message(1, "test", "date", true, false, false),
    Message(2, "Test2", "date2", false, false, false),
    Message(3, "fdgger gerggr ", "date3", true, false, false),
    Message(4, "test4", "date4", false, false, false),
    Message(5, "test5", "date5", true, false, false),
    Message(6, "test6", "date6", false, false, false),
  ];*/
}
