import 'package:flutter/cupertino.dart';

final String tableReplies = 'replies';

class ReplyField {
  static final List<String> values = [
    id,
    idScenario,
    createdTime,
    textEN,
    textFR,
    textJP,
    idQuestion,
    nameVariable,
    dataType,
    dataValue,
  ];

  static const String id = '_id';
  static const String idScenario = 'idScenario';
  static const String textEN = 'textEN';
  static const String textFR = 'textFR';
  static const String textJP = 'textJP';
  static const String idQuestion = 'idQuestion';
  static const String nameVariable = 'nameVariable';
  static const String createdTime = 'createdTime';
  static const String dataType = 'dataType';
  static const String dataValue = 'dataValue';
}

/* Reply est une réponse fermée de l'utilisateur dans 
*  un scénario
*/
class Reply {
  int id;
  int idScenario;
  DateTime createdTime;
  String textEN;
  String textFR;
  String textJP;
  int idQuestion;
  String nameVariable;
  String dataType; //Type : physically, mentally, socially
  int dataValue;

  Reply({
    this.id,
    @required this.idScenario,
    @required this.createdTime,
    this.textEN = '',
    this.textFR = '',
    this.textJP = '',
    this.idQuestion = 0,
    this.nameVariable = '',
    this.dataType = '',
    this.dataValue = 0,
  });

  Reply copy({
    int id,
    int idScenario,
    DateTime createdTime,
    String textEN,
    String textFR,
    String textJP,
    int idQuestion,
    String nameVariable,
    String dataType,
    int dataValue,
  }) =>
      Reply(
        id: id ?? this.id,
        idScenario: idScenario ?? this.idScenario,
        createdTime: createdTime ?? this.createdTime,
        textEN: textEN ?? this.textEN,
        textFR: textFR ?? this.textFR,
        textJP: textJP ?? this.textJP,
        idQuestion: idQuestion ?? this.idQuestion,
        nameVariable: nameVariable ?? this.nameVariable,
        dataType: dataType ?? this.dataType,
        dataValue: dataValue ?? this.dataValue,
      );

  //Transforme un Json en map
  static Reply fromJson(Map<String, Object> json) => Reply(
        id: json[ReplyField.id] as int,
        idScenario: json[ReplyField.idScenario] as int,
        textEN: json[ReplyField.textEN] as String,
        textFR: json[ReplyField.textFR] as String,
        textJP: json[ReplyField.textJP] as String,
        idQuestion: json[ReplyField.idQuestion] as int,
        nameVariable: json[ReplyField.nameVariable] as String,
        dataType: json[ReplyField.dataType] as String,
        dataValue: json[ReplyField.dataValue] as int,
        /*createdTime: DateTime.parse(
        json[ReplyField.createdTime] as String,
      ),*/
      );

  //Transforme une map to Json
  Map<String, Object> toJson() => {
        ReplyField.id: id,
        ReplyField.idScenario: idScenario,
        ReplyField.textEN: textEN,
        ReplyField.textFR: textFR,
        ReplyField.textJP: textJP,
        ReplyField.idQuestion: idQuestion,
        ReplyField.nameVariable: nameVariable,
        ReplyField.createdTime: createdTime.toIso8601String(),
        ReplyField.dataType: dataType,
        ReplyField.dataValue: dataValue,
      };
}
