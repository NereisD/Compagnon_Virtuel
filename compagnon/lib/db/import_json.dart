import 'dart:convert';
import 'dart:io';
import 'package:compagnon/db/message_database.dart';
import 'package:compagnon/db/scenarios_database.dart';
import 'package:compagnon/models/Message.dart';
import 'package:compagnon/models/question.dart';
import 'package:compagnon/models/relation_question_reply.dart';
import 'package:compagnon/models/reply.dart';
import 'package:flutter/services.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

//Renvoie le path du ficher dans lequel écrire
Future<String> getLocalPath() async {
  Future<String> directory;
  if (Platform.isAndroid) {
    final directory = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
  } else {
    final directory = await getApplicationDocumentsDirectory();
  }

  return directory;
}

/* Creer un pop up qui demande a l'utilisateur si l'application
* peut accéder à ses dossiers en écriture
*/
void requestPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();
}

Future<int> importScenarios(bool isFirstLaunch) async {
  String response;

  //Si c'est le premier lancement de l'application on importe en local
  if (isFirstLaunch) {
    print("importScenarios firstLaunch");
    response = await rootBundle.loadString('lib/json/items_scenarios.json');

    //Sinon on importe depuis le répertoire Downloads
  } else {
    print("importScenarios NOT firstLaunch");
    getLocalPath().then(
      (String affichePath) async {
        print("directory path: " + affichePath);

        try {
          //Créer un nouveau fichier
          response = await rootBundle
              .loadString(affichePath + "/items_scenarios.json");
          // response =
          // await rootBundle.loadString('lib/json/items_scenarios.json');
          //Sinon on affiche l'erreur
        } catch (e) {
          print('Error $e : PATH invalide');
          return 1;
        }
      },
    );
  }

  final data = await json.decode(response);

  //Creation des questions
  List listQuestions = data["questions"];
  List<Question> questions = [];

  //listQuestions.forEach((item) => questions.add(Question.fromJson(item)));

  //On remplit les questions
  for (var json in listQuestions) {
    //convertis json en object
    Question item = Question.fromJson(json);
    //Appel du constructeur
    questions.add(Question(
      idScenario: item.idScenario ?? 0,
      createdTime: item.createdTime ?? DateTime.now(),
      textEN: item.textEN ?? '',
      textFR: item.textFR ?? '',
      textJP: item.textJP ?? '',
      idNextQuestion: item.idNextQuestion ?? 0,
      isOpenQuestion: item.isOpenQuestion ?? false,
      isFirst: item.isFirst ?? false,
      isEnd: item.isEnd ?? false,
      nameVariable: item.nameVariable ?? '',
    ));
  }

  //Creation des réponses
  List listReplies = data["replies"];
  List<Reply> replies = [];

  //listReplies.forEach((item) => replies.add(Reply.fromJson(item)));

  for (var json in listReplies) {
    Reply item = Reply.fromJson(json);

    replies.add(Reply(
      idScenario: item.idScenario ?? 0,
      createdTime: item.createdTime ?? DateTime.now(),
      textEN: item.textEN ?? '',
      textFR: item.textFR ?? '',
      textJP: item.textJP ?? '',
      idQuestion: item.idQuestion ?? 0,
      nameVariable: item.nameVariable ?? '',
    ));
  }

  //Creation des relations QR
  List listRelationsQR = data["relationsQR"];
  List<RelationQR> relationsQR = [];

  //listRelationsQR.forEach((item) => relationsQR.add(RelationQR.fromJson(item)));

  for (var json in listRelationsQR) {
    RelationQR item = RelationQR.fromJson(json);

    relationsQR.add(RelationQR(
      idScenario: item.idScenario ?? 0,
      createdTime: item.createdTime ?? DateTime.now(),
      idQuestion: item.idQuestion ?? 0,
      idReply: item.idReply ?? 0,
    ));
  }

  // ======================================
  //On supprime les tables Questions, Reponses et relationsQR
  ScenariosDatabase.instance.dropTableQuestions();
  ScenariosDatabase.instance.dropTableReplies();
  ScenariosDatabase.instance.dropTableRelationsQR();

  //Puis on les recreer
  ScenariosDatabase.instance.createTableQuestions();
  ScenariosDatabase.instance.createTableReplies();
  ScenariosDatabase.instance.createTableRelationsQR();

  /*
  final message = Message(
    date: DateTime.now(),
    text: "message Test2",
    isSentByMe: false,
  );

  MessageDatabase.instance.create(message);

  final test = Question(
    idScenario: 0,
    createdTime: DateTime.now(),
    isOpenQuestion: false,
    textFR: "question TEST",
  );
  ScenariosDatabase.instance.createQuestion(test);*/

  // ======================================
  //On creer les questions
  for (int i = 0; i < questions.length; i++) {
    ScenariosDatabase.instance.createQuestion(questions[i]); //Ici ça marche pas
  }

  //Les réponses
  for (int i = 0; i < replies.length; i++) {
    ScenariosDatabase.instance.createReply(replies[i]);
  }

  //Les relationsQR
  for (int i = 0; i < relationsQR.length; i++) {
    ScenariosDatabase.instance.createRelationQR(relationsQR[i]);
  }

  //Pour voir la DB nouvellement créée
  displayDB();

  return 0;
}

/* Affiche la base de données
*/
void displayDB() {
  //Affiche la base des questions
  ScenariosDatabase.instance.readAllQuestions().then((liste) {
    print("----- table questions ----- taille :");
    print(liste.length);
    for (var l in liste) {
      print(l.id);
      print(l.textFR);
    }
  });

  //Affiche la base des réponses
  ScenariosDatabase.instance.readAllReplies().then((liste) {
    print("----- table réponses ----- taille :");
    print(liste.length);
    for (var l in liste) {
      print(l.id);
      print(l.textFR);
    }
  });

  //Affiche la base des relationsQR
  ScenariosDatabase.instance.readAllRelationsQR().then((liste) {
    print("----- table relations QR ----- taille :");
    print(liste.length);
    for (var l in liste) {
      print(l.idQuestion);
      print(l.idReply);
    }
  });
}
