import 'package:flutter/cupertino.dart';

final String tableRelationsQR = 'relationsQR';

class RelationQRField {
  static final List<String> values = [
    id,
    idScenario,
    idQuestion,
    idReply,
    createdTime,
  ];

  static const String id = '_id';
  static const String idScenario = 'idScenario';
  static const String idQuestion = 'idQuestion';
  static const String idReply = 'idReply';
  static const String createdTime = 'createdTime';
}

/* RelationQR représente la relation entre une question
*  du robot et une liste de réponses fermées dans
*  un scénario.
*/
class RelationQR {
  int id;
  int idScenario;
  DateTime createdTime;
  int idQuestion; //Nom de la variable
  int idReply; //valeur (exemple : 'homme')

  RelationQR({
    this.id,
    @required this.idScenario,
    @required this.createdTime,
    @required this.idQuestion,
    @required this.idReply,
  });

  RelationQR copy({
    int id,
    int idScenario,
    DateTime createdTime,
    int idQuestion,
    int idReply,
  }) =>
      RelationQR(
        id: id ?? this.id,
        idScenario: idScenario ?? this.idScenario,
        createdTime: createdTime ?? this.createdTime,
        idQuestion: idQuestion ?? this.idQuestion,
        idReply: idReply ?? this.idReply,
      );

  //Transforme un Json en map
  static RelationQR fromJson(Map<String, Object> json) => RelationQR(
      id: json[RelationQRField.id] as int,
      idScenario: json[RelationQRField.idScenario] as int,
      idQuestion: json[RelationQRField.idQuestion] as int,
      idReply: json[RelationQRField.idReply] as int,
      createdTime: DateTime.parse(
        json[RelationQRField.createdTime] as String,
      ));

  //Transforme une map to Json
  Map<String, Object> toJson() => {
        RelationQRField.id: id,
        RelationQRField.idScenario: idScenario,
        RelationQRField.idQuestion: idQuestion,
        RelationQRField.idReply: idReply,
        RelationQRField.createdTime: createdTime.toIso8601String(),
      };
}
