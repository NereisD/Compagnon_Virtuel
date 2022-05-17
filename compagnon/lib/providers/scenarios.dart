import 'package:compagnon/constants.dart';
import 'package:compagnon/models/relation_question_reply.dart';
import 'package:compagnon/models/question.dart';
import 'package:compagnon/models/reply.dart';
import 'package:compagnon/models/variable.dart';
import 'package:flutter/cupertino.dart';

class ScenarioProvider extends ChangeNotifier {
  List<Question> _questions = [];

  List<Reply> _replies = [];

  List<RelationQR> _relationsQR = [];

  /* nom, prénom, age, idScénarioActuel, idQuestionActuel, lang
  */
  List<Variable> _variables = [];

  /* getScenarioQuestions renvoie la liste de questions correspondantes a
  *  un id de scenario souhaité
  */
  List<Question> getScenarioQuestions(int idScenario) {
    return _questions
        .where((question) => question.idScenario == idScenario)
        .toList();
  }

  /* getScenarioReplies renvoie la liste de réponses correspondantes a
  *  un id de scenario souhaité
  */
  List<Reply> getScenarioReplies(int idScenario) {
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
  *  en fonction d'une question, en passant par la table QR
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
  int typeReplyOfQuestion(Question question) {
    if (question.isEnd) {
      return 0;
    } else if (question.isOpenQuestion) {
      return 1;
    } else if (question.idNextQuestion == null) {
      return 2;
    } else {
      return 3;
    }
  }
}
