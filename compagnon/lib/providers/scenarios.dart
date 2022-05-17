// ignore_for_file: prefer_final_fields

import 'package:compagnon/constants.dart';
import 'package:compagnon/models/relation_question_reply.dart';
import 'package:compagnon/models/question.dart';
import 'package:compagnon/models/reply.dart';
import 'package:compagnon/models/variable.dart';
import 'package:flutter/cupertino.dart';

class ScenarioProvider extends ChangeNotifier {
  List<Question> _questions = [
    Question(
      idScenario: 2,
      createdTime: DateTime.now(),
      textFR: "Question scénario 2",
      isFirst: true,
      isOpenQuestion: false,
    ),
    Question(
      idScenario: 1,
      createdTime: DateTime.now(),
      isOpenQuestion: false,
      textFR: "Bonjour, je m'appelle Bob.",
      idNextQuestion: 2,
      isFirst: true,
      isEnd: false,
    ),
    Question(
      idScenario: 1,
      createdTime: DateTime.now(),
      isOpenQuestion: false,
      textFR: "Aimez-vous les bananes ?",
    ),
    Question(
      idScenario: 1,
      createdTime: DateTime.now(),
      textFR: "Moi aussi, j'adore !",
      isOpenQuestion: false,
      isEnd: true,
    ),
    Question(
      idScenario: 1,
      createdTime: DateTime.now(),
      textFR: "Quel fruit préférez-vous ?",
      isOpenQuestion: true,
      isEnd: false,
    )
  ];

  List<Reply> _replies = [
    Reply(
      idScenario: 1,
      createdTime: DateTime.now(),
      textFR: "Oui j'aime les bananes",
      idQuestion: 2, //Pas sur (commence a 0 ou 1 ?)
    ),
    Reply(
      idScenario: 1,
      createdTime: DateTime.now(),
      textFR: "Non je n'aime pas",
      idQuestion: 3,
    ),
    Reply(
      idScenario: 2,
      createdTime: DateTime.now(),
      textFR: "Reply senario2",
    )
  ];

  List<RelationQR> _relationsQR = [
    RelationQR(
      createdTime: DateTime.now(),
      idQuestion: 1,
      idReply: 0,
    ),
    RelationQR(
      createdTime: DateTime.now(),
      idQuestion: 1,
      idReply: 1,
    )
  ];

  /* nom, prénom, age, idScénarioActuel, idQuestionActuel, lang
  */
  List<Variable> _variables = [
    Variable(
      createdTime: DateTime.now(),
      name: "name",
    ),
    Variable(
      createdTime: DateTime.now(),
      name: "age",
    ),
    Variable(
      createdTime: DateTime.now(),
      name: "lang",
      value: "fr",
    ),
    Variable(
      createdTime: DateTime.now(),
      name: "idCurrentScenario",
    ),
    Variable(
      createdTime: DateTime.now(),
      name: "idCurrentQuestion",
    ),
  ];

  /* getScenarioQuestions renvoie la liste de questions correspondantes a
  *  un id de scenario souhaité
  */
  List<Question> getScenarioQuestions(int idScenario) {
    //ICI il faudra init toutes les questions de puis la base
    return _questions
        .where((question) => question.idScenario == idScenario)
        .toList();
  }

  /* getScenarioReplies renvoie la liste de réponses correspondantes a
  *  un id de scenario souhaité
  */
  List<Reply> getScenarioReplies(int idScenario) {
    //ICI il faudra init toutes les réponses depuis la base
    return _replies.where((reply) => reply.idScenario == idScenario).toList();
  }

  /* getQuestionByReply renvoie un la question qui suit une réponse
  *  fermée de l'utilisateur. 
  *  Attention : Ne pas appeller cette fontion lorsque c'est la dernière 
  *  réplique (c'est à dire reply.idQuestion == null)
  */
  Question getQuestionByReply(Reply reply) {
    List<Question> theQuestion =
        _questions.where((question) => question.id == reply.idQuestion);
    if (theQuestion.length != 1) {
      print("Error : theQuestion.length != 1");
      return null;
    }
    return theQuestion[0];
  }

  /* getRepliesByQuestion renvoie la liste de réponses 
  *  en fonction d'une question fermée, en passant par la table QR.
  *  Attention : ne pas appeller cette fonction lorsqu'il n'y a pas
  *  de réponse fermée attendue à la question posée.
  *  Pas de réponse fermée si : isOpenQuestion = true ou si isEnd = true 
  *  ou si idNextQuestion != null 
  */
  List<Reply> getRepliesByQuestion(Question question) {
    List<RelationQR> relations =
        _relationsQR.where((r) => r.idQuestion == question.id).toList();

    List<Reply> replies = [];

    for (int i = 0; i < relations.length; i++) {
      for (int j = 0; j < _replies.length; j++) {
        if (_replies[j].id == relations[i].idReply) {
          replies.add(_replies[j]);
        }
      }
    }
    return replies;
  }

  /* Retourne le type de réponse attendue après une question 
  *  0 : dernière réplique
  *  1 : question ouverte
  *  2 : question fermée 
  *  3 : robot continue
  */
  int typeOfQuestion(Question question) {
    if (question.isEnd) {
      endScenario(); //Termine le scénario
      return 0;
    } else if (question.isOpenQuestion) {
      return 1;
    } else if (question.idNextQuestion == null) {
      return 2;
    } else {
      return 3;
    }
  }

  /* Retourne un bool pour savoir si la réponse conclue le scénario.
  *  true : c'est la dernière réplique
  *  false : le robot conitnue 
  */
  bool replyIsEnd(Reply reply) {
    if (reply.idQuestion == null) {
      endScenario(); //Termine le scénario
      return true;
    } else {
      return false;
    }
  }

  /* Modifie une variable en fonction du nom.
  *  Si elle n'existe pas encore, on la créer.
  */
  void setVariable(String name, String value) {
    bool nameExist = false;
    for (int i = 0; i < _variables.length; i++) {
      if (_variables[i].name == name) {
        nameExist = true;
        _variables[i].value = value;
        //ICI il faudra la modifier en base
      }
    }
    //Si la variable n'existe pas, on la créer
    if (!nameExist) {
      _variables.add(
        Variable(
          createdTime: DateTime.now(),
          name: name,
          value: value,
        ),
      );
      //ICI il faudra la créer en base
    }
  }

  /* Renvoie la première question d'un scénario
  *  Si on ne la trouve pas renvoie une erreur
  */
  Question getFirstQuestion() {
    for (int i = 0; i < _questions.length; i++) {
      if (_questions[i].isFirst) {
        return _questions[i];
      }
    }
    print("Error : No first question");
    return null;
  }

  /* Termine un scénario en passant les idCurrent à null
  */
  void endScenario() {
    setVariable("idCurrentScenario", null);
    setVariable("idCurrentQuestion", null);
  }

  /* Démarre un scénario
  */
  void initScenario(int id) {
    //On init le scenario
    _questions = getScenarioQuestions(id);
    _replies = getScenarioReplies(id);

    //On récupère la première question
    Question firstQuestion = getFirstQuestion();

    //On met a jour les variables
    setVariable("idCurrentScenario", id.toString());
    setVariable("idCurrentQuestion", firstQuestion.id.toString());
  }
}
