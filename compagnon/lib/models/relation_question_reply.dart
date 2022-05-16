import 'package:flutter/cupertino.dart';

final String tableRelationsQR = 'relationsQR';

class RelationQRField {
  static final List<String> values = [
    id,
    idQuestion,
    idReply,
    createdTime,
  ];

  static const String id = '_id';
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
  DateTime createdTime;
  int idQuestion; //Nom de la variable
  int idReply; //valeur (exemple : 'homme')

  RelationQR({
    this.id,
    @required this.createdTime,
    @required this.idQuestion,
    @required this.idReply,
  });

  RelationQR copy({
    int id,
    DateTime createdTime,
    int idQuestion,
    int idReply,
  }) =>
      RelationQR(
        id: id ?? this.id,
        createdTime: createdTime ?? this.createdTime,
        idQuestion: idQuestion ?? this.idQuestion,
        idReply: idReply ?? this.idReply,
      );

  //Transforme un Json en map
  static RelationQR fromJson(Map<String, Object> json) => RelationQR(
      id: json[RelationQRField.id] as int,
      idQuestion: json[RelationQRField.idQuestion] as int,
      idReply: json[RelationQRField.idReply] as int,
      createdTime: DateTime.parse(
        json[RelationQRField.createdTime] as String,
      ));

  //Transforme une map to Json
  Map<String, Object> toJson() => {
        RelationQRField.id: id,
        RelationQRField.idQuestion: idQuestion,
        RelationQRField.idReply: idReply,
        RelationQRField.createdTime: createdTime.toIso8601String(),
      };
}
