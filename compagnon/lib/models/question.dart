import 'package:flutter/cupertino.dart';

final String tableQuestions = 'questions';

class QuestionField {
  static final List<String> values = [
    id,
    idScenario,
    createdTime,
    textEN,
    textFR,
    textJP,
    idNextQuestion,
    isOpenQuestion,
    isFirst,
    isEnd,
    nameVariable
  ];

  static const String id = '_id';
  static const String idScenario = 'idScenario';
  static const String createdTime = 'createdTime';
  static const String textEN = 'textEN';
  static const String textFR = 'textFR';
  static const String textJP = 'textJP';
  static const String idNextQuestion = 'idNextQuestion';
  static const String isOpenQuestion = 'isOpenQuestion';
  static const String isFirst = 'isFirst';
  static const String isEnd = 'isEnd';
  static const String nameVariable = 'nameVariable';
}

/* Question est une question du robot dans
*  un scénario, plusieurs questions peuvent être
*  succéssives. 
*/
class Question {
  int id;
  int idScenario;
  DateTime createdTime;
  String textEN;
  String textFR;
  String textJP;
  int idNextQuestion;
  bool isOpenQuestion;
  bool isFirst;
  bool isEnd;
  String nameVariable;

  Question({
    this.id,
    @required this.idScenario,
    @required this.createdTime,
    this.textEN = '',
    this.textFR = '',
    this.textJP = '',
    this.idNextQuestion = 0,
    this.isOpenQuestion = false,
    this.isFirst = false,
    this.isEnd = false,
    this.nameVariable = '',
  });

  Question copy({
    int id,
    int idScenario,
    DateTime createdTime,
    String textEN,
    String textFR,
    String textJP,
    int idNextQuestion,
    bool isOpenQuestion,
    bool isFirst,
    bool isEnd,
    String nameVariable,
  }) =>
      Question(
        id: id ?? this.id,
        idScenario: idScenario ?? this.idScenario,
        createdTime: createdTime ?? this.createdTime,
        textEN: textEN ?? this.textEN,
        textFR: textFR ?? this.textFR,
        textJP: textJP ?? this.textJP,
        idNextQuestion: idNextQuestion ?? this.idNextQuestion,
        isOpenQuestion: isOpenQuestion ?? this.isOpenQuestion,
        isFirst: isFirst ?? this.isFirst,
        isEnd: isEnd ?? this.isEnd,
        nameVariable: nameVariable ?? this.nameVariable,
      );

  //Transforme un Json en map
  static Question fromJson(Map<String, Object> json) => Question(
      id: json[QuestionField.id] as int,
      idScenario: json[QuestionField.idScenario] as int,
      textEN: json[QuestionField.textEN] as String,
      textFR: json[QuestionField.textFR] as String,
      textJP: json[QuestionField.textJP] as String,
      idNextQuestion: json[QuestionField.idNextQuestion] as int,
      isOpenQuestion:
          json[QuestionField.isOpenQuestion] == 1, //True si 1 false si 0
      isFirst: json[QuestionField.isFirst] == 1,
      isEnd: json[QuestionField.isEnd] == 1,
      nameVariable: json[QuestionField.nameVariable] as String,
      createdTime: DateTime.parse(
        json[QuestionField.createdTime] as String,
      ));

  //Transforme une map to Json
  Map<String, Object> toJson() => {
        QuestionField.id: id,
        QuestionField.idScenario: idScenario,
        QuestionField.textEN: textEN,
        QuestionField.textFR: textFR,
        QuestionField.textJP: textJP,
        QuestionField.idNextQuestion: idNextQuestion,
        QuestionField.isOpenQuestion: isOpenQuestion ? 1 : 0,
        QuestionField.isFirst: isFirst ? 1 : 0,
        QuestionField.isEnd: isEnd ? 1 : 0,
        QuestionField.nameVariable: nameVariable,
        QuestionField.createdTime: createdTime.toIso8601String(),
      };

  void displayContent() {
    print("--- Content question : ---");
    print("id : $id");
    print("idScenario : $idScenario");
    print("textEN : $textEN");
    print("textFR : $textFR");
    print("textJP : $textJP");
    print("idNextQuestion : $idNextQuestion");
    print("isOpenQuestion : $isOpenQuestion");
    print("isFirst : $isFirst");
    print("isEnd : $isEnd");
    print("nameVariable : $nameVariable");
    print("createdTime : $createdTime");
  }
}
