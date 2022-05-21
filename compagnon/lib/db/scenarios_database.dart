import 'package:compagnon/models/question.dart';
import 'package:compagnon/models/reply.dart';
import 'package:compagnon/models/relation_question_reply.dart';
import 'package:compagnon/models/variable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ScenariosDatabase {
  static final ScenariosDatabase instance = ScenariosDatabase._init();

  static Database _database;

  ScenariosDatabase._init();

  //Ouvrir une connextion avec la DB
  Future<Database> get database async {
    //Si elle existe déjà on la retourne directement
    if (_database != null) return _database;

    _database = await _initDB('scenarios.db');
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
CREATE TABLE $tableReplies(
  ${ReplyField.id} $idType,
  ${ReplyField.idScenario} $integerType,
  ${ReplyField.textEN} $textType,
  ${ReplyField.textFR} $textType,
  ${ReplyField.textJP} $textType,
  ${ReplyField.idQuestion} $integerType,
  ${ReplyField.nameVariable} $textType,
  ${ReplyField.createdTime} $textType
)
''');

    await db.execute('''
CREATE TABLE $tableQuestions(
  ${QuestionField.id} $idType,
  ${QuestionField.idScenario} $integerType,
  ${QuestionField.createdTime} $integerType,
  ${QuestionField.textEN} $textType,
  ${QuestionField.textFR} $textType,
  ${QuestionField.textJP} $textType,
  ${QuestionField.idNextQuestion} $integerType,
  ${QuestionField.isOpenQuestion} $boolType,
  ${QuestionField.isFirst} $boolType,
  ${QuestionField.isEnd} $boolType,
  ${QuestionField.nameVariable} $textType
)
''');

    await db.execute('''
CREATE TABLE $tableRelationsQR(
  ${RelationQRField.id} $idType,
  ${RelationQRField.idScenario} $integerType,
  ${RelationQRField.idQuestion} $integerType,
  ${RelationQRField.idReply} $integerType,
  ${RelationQRField.createdTime} $textType
)
''');

    await db.execute('''
CREATE TABLE $tableVariables(
  ${VariableField.id} $idType,
  ${VariableField.name} $textType,
  ${VariableField.value} $textType,
  ${VariableField.createdTime} $textType
)
''');
  }

  /* ========== CRUD Réponses ========== */

  //Créer une réponse
  Future<Reply> createReply(Reply reply) async {
    final db = await instance.database;
    //id généré par la db
    final id = await db.insert(tableReplies, reply.toJson());
    return reply.copy(id: id);
  }

  //Récupère une réponse en fonction de son ID
  Future<Reply> readReply(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableReplies,
      columns: ReplyField.values,
      /* Pour chaque '?' on associe un paramètre afin d'éviter les
      * injections SQL
      */
      where: '${ReplyField.id} = ?',
      whereArgs: [id],
    );

    //Si la requête est un succès
    if (maps.isNotEmpty) {
      /* On peut recuperer seulement le 1er item car on 
      * ne retourne qu'une seule note
      */
      return Reply.fromJson(maps.first);
    } else {
      throw Exception('ID $id Reply is not found');
    }
  }

  //Renvoie toutes les réponses
  Future<List<Reply>> readAllReplies() async {
    final db = await instance.database;

    const orderBy = '${ReplyField.createdTime} ASC';
    final result = await db.query(tableReplies, orderBy: orderBy);

    return result.map((json) => Reply.fromJson(json)).toList();
  }

  //Modifie une réponse
  Future<int> updateReply(Reply reply) async {
    final db = await instance.database;

    return db.update(
      tableReplies,
      reply.toJson(),
      where: '${ReplyField.id} = ?',
      whereArgs: [reply.id],
    );
  }

  //Supprime une réponse
  Future<int> deleteReply(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableReplies,
      where: '${ReplyField.id} = ?',
      whereArgs: [id],
    );
  }

  /* ========== CRUD Questions ========== */

  //Créer une question
  Future<Question> createQuestion(Question question) async {
    final db = await instance.database;
    //id généré par la db
    final id = await db.insert(tableQuestions, question.toJson());
    return question.copy(id: id);
  }

  //Récupère une question en fonction de son ID
  Future<Question> readQuestion(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableQuestions,
      columns: QuestionField.values,
      where: '${QuestionField.id} = ?',
      whereArgs: [id],
    );

    //Si la requête est un succès
    if (maps.isNotEmpty) {
      return Question.fromJson(maps.first);
    } else {
      throw Exception('ID $id Question is not found');
    }
  }

  //Renvoie toutes les questions
  Future<List<Question>> readAllQuestions() async {
    final db = await instance.database;

    const orderBy = '${QuestionField.createdTime} ASC';
    final result = await db.query(tableQuestions, orderBy: orderBy);

    return result.map((json) => Question.fromJson(json)).toList();
  }

  //Modifie une question
  Future<int> updateQuestion(Question question) async {
    final db = await instance.database;

    return db.update(
      tableQuestions,
      question.toJson(),
      where: '${QuestionField.id} = ?',
      whereArgs: [question.id],
    );
  }

  //Supprime une question
  Future<int> deleteQuestion(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableQuestions,
      where: '${QuestionField.id} = ?',
      whereArgs: [id],
    );
  }

  /* ========== CRUD Relation QR ========== */

  //Créer une relation entre questions et réponses
  Future<RelationQR> createRelationQR(RelationQR relation) async {
    final db = await instance.database;
    //id généré par la db
    final id = await db.insert(tableRelationsQR, relation.toJson());
    return relation.copy(id: id);
  }

  //Récupère une relationQR en fonction de son ID
  Future<RelationQR> readRelationQR(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableRelationsQR,
      columns: RelationQRField.values,
      where: '${RelationQRField.id} = ?',
      whereArgs: [id],
    );

    //Si la requête est un succès
    if (maps.isNotEmpty) {
      return RelationQR.fromJson(maps.first);
    } else {
      throw Exception('ID $id RelationQR is not found');
    }
  }

  //Renvoie toutes les relations QR
  Future<List<RelationQR>> readAllRelationsQR() async {
    final db = await instance.database;

    const orderBy = '${RelationQRField.createdTime} ASC';
    final result = await db.query(tableRelationsQR, orderBy: orderBy);

    return result.map((json) => RelationQR.fromJson(json)).toList();
  }

  //Modifie une relation QR
  Future<int> updateRelationQR(RelationQR relation) async {
    final db = await instance.database;

    return db.update(
      tableRelationsQR,
      relation.toJson(),
      where: '${RelationQRField.id} = ?',
      whereArgs: [relation.id],
    );
  }

  //Supprime une relation QR
  Future<int> deleteRelationQR(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableRelationsQR,
      where: '${RelationQRField.id} = ?',
      whereArgs: [id],
    );
  }

  /* ========== CRUD variables ========== */

  //Créer une variable
  Future<Variable> createVariable(Variable variable) async {
    final db = await instance.database;
    //id généré par la db
    final id = await db.insert(tableVariables, variable.toJson());
    return variable.copy(id: id);
  }

  //Récupère une variable en fonction de son ID
  Future<Variable> readVariable(String name) async {
    final db = await instance.database;

    final maps = await db.query(
      tableVariables,
      columns: VariableField.values,
      where: '${VariableField.name} = ?',
      whereArgs: [name],
    );

    //Si la requête est un succès
    if (maps.isNotEmpty) {
      return Variable.fromJson(maps.first);
    } else {
      return null;
    }
  }

  //Renvoie toutes les variables
  Future<List<Variable>> readAllVariables() async {
    final db = await instance.database;

    const orderBy = '${VariableField.createdTime} ASC';
    final result = await db.query(tableVariables, orderBy: orderBy);

    return result.map((json) => Variable.fromJson(json)).toList();
  }

  //Modifie une variable
  Future<int> updateVariable(Variable variable) async {
    final db = await instance.database;

    return db.update(
      tableVariables,
      variable.toJson(),
      where: '${VariableField.id} = ?',
      whereArgs: [variable.id],
    );
  }

  //Supprime une variable
  Future<int> deleteVariable(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableVariables,
      where: '${VariableField.id} = ?',
      whereArgs: [id],
    );
  }

  /* ========== Close DB ========== */

  //Close DB
  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
