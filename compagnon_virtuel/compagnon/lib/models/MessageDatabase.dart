import 'package:compagnon/models/Message.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MessageDatabase {
  MessageDatabase._();

  static final MessageDatabase instance = MessageDatabase._();
  static Database _database;

  Future<Database> get database async {
    if  (_database != null) return _database;
    _database = await initDB();
    return _database;
  }


  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'message_Database.db'),
      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE message(id INTEGER PRIMARY KEY,text TEXT,date TEXT,isSentByMe INTEGER,isLiked INTEGER,isSecret INTEGER)"
        );
      },
      version : 1,
    );
  }


  void insertMessage(Message message) async{
    final Database db = await database;

    await db.insert('message',
     message.toMap(),
     conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void updateMessage(Message message) async{
    final Database db = await database;
    await db.update("message",
     message.toMap(),
     where: "title = ?", whereArgs: [message.id]);
  }

  void deleteMessage(int id)async{
    final Database db = await database;
    db.delete("message", where: "title = ?", whereArgs: [id]);
  }

  Future<List<Message>> messages() async{
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('message');
    List<Message> messages = List.generate(maps.length, (i){
      return Message.fromMap(maps[i]);
    });

    if (messages.isEmpty) {
      for (Message message in defaultMessages){
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

  ];
}