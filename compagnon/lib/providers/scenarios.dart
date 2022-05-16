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

  /* nom, prénom, age, idScénarioActuel, idQuestion, lang
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
  */
  Iterable<Question> getQuestionByReply(Reply reply) {
    return _questions.where((question) => question.id == reply.idQuestion);
  }

  /* getRepliesByQuestion renvoie la liste de réponses 
  *  en fonction d'une question, en passant par la table QR
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
}
