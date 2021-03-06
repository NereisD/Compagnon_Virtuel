// ignore_for_file: prefer_final_fields

import 'package:compagnon/values/constants.dart';
import 'package:compagnon/db/message_database.dart';
import 'package:compagnon/db/scenarios_database.dart';
import 'package:compagnon/db/scenarios_database.dart';
import 'package:compagnon/models/Message.dart';
import 'package:compagnon/models/question.dart';
import 'package:compagnon/models/relation_question_reply.dart';
import 'package:compagnon/models/reply.dart';
import 'package:compagnon/models/variable.dart';
import 'package:compagnon/values/languages.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

class Scenario {
  //On initialise les listes vides
  List<Question> _questions = [];
  List<Reply> _replies = [];
  List<RelationQR> _relationsQR = [];
  List<Variable> _variables = [];
  List<Reply> currentReplies = []; //PAS init via DB

  //On initialise les booléens utiles
  bool isClosedQuestion = false;
  bool isOpenQuestion = false;
  bool isResumeScenario = false;

  /*
  List<Question> _questions = [
    Question(
      id: 1,
      idScenario: 2,
      createdTime: DateTime.now(),
      textFR: "Question scénario 2",
      isFirst: true,
      isOpenQuestion: false,
    ),
    Question(
      id: 2,
      idScenario: 1,
      createdTime: DateTime.now(),
      isOpenQuestion: false,
      textFR: "Bonjour, je m'appelle Bob.",
      idNextQuestion: 3,
      isFirst: true,
      isEnd: false,
    ),
    Question(
      id: 3,
      idScenario: 1,
      createdTime: DateTime.now(),
      isOpenQuestion: false,
      textFR: "Aimez-vous les bananes ?",
    ),
    Question(
      id: 4,
      idScenario: 1,
      createdTime: DateTime.now(),
      textFR: "Moi aussi, j'adore !",
      isOpenQuestion: false,
      isEnd: true,
    ),
    Question(
      id: 5,
      idScenario: 1,
      createdTime: DateTime.now(),
      textFR: "Quel fruit préférez-vous ?",
      isOpenQuestion: true,
      idNextQuestion: 6,
      isEnd: false,
      nameVariable: "favoriteFruit",
    ),
    Question(
      id: 6,
      idScenario: 1,
      createdTime: DateTime.now(),
      //textFR: "Les ${getVariableByName("favoriteFruit")} ont du gout",
      textFR: "Les %%favoriteFruit ont du gout",
      isOpenQuestion: false,
      isEnd: true,
    )
  ];

  List<Reply> _replies = [
    Reply(
      id: 1,
      idScenario: 2,
      createdTime: DateTime.now(),
      textFR: "Reply senario2",
    ),
    Reply(
      id: 2,
      idScenario: 1,
      createdTime: DateTime.now(),
      textFR: "Oui j'aime les bananes",
      idQuestion: 4, //Pas sur (commence a 0 ou 1 ?)
    ),
    Reply(
      id: 3,
      idScenario: 1,
      createdTime: DateTime.now(),
      textFR: "Non je n'aime pas",
      idQuestion: 5,
    ),
  ];

  List<RelationQR> _relationsQR = [
    RelationQR(
      id: 1,
      idScenario: 1,
      createdTime: DateTime.now(),
      idQuestion: 3,
      idReply: 2,
    ),
    RelationQR(
      id: 2,
      idScenario: 1,
      createdTime: DateTime.now(),
      idQuestion: 3,
      idReply: 3,
    )
  ];

  /* nom, prénom, age, idScénarioActuel, idQuestionActuel, lang
  */
  List<Variable> _variables = [
    Variable(
      id: 1,
      createdTime: DateTime.now(),
      name: "name",
    ),
    Variable(
      id: 2,
      createdTime: DateTime.now(),
      name: "age",
    ),
    Variable(
      id: 3,
      createdTime: DateTime.now(),
      name: "lang",
      value: "fr",
    ),
    Variable(
      id: 4,
      createdTime: DateTime.now(),
      name: "idCurrentScenario",
    ),
    Variable(
      id: 5,
      createdTime: DateTime.now(),
      name: "idCurrentQuestion",
    ),
  ];*/

  /* ============================================
  *  Il faudra un constructeur qui récupère en base les variables
  *  (pour lancer resumesOngoingScenario)
  *  ============================================
  */

  /* getScenarioQuestions renvoie la liste de questions correspondantes a
  *  un id de scenario souhaité
  */
  Future<List<Question>> getScenarioQuestions(int idScenario) async {
    //Appel DB questions

    _questions = await ScenariosDatabase.instance.readAllQuestions();
    return _questions
        .where((question) => question.idScenario == idScenario)
        .toList();
  }

  /* getScenarioReplies renvoie la liste de réponses correspondantes a
  *  un id de scenario souhaité
  */
  Future<List<Reply>> getScenarioReplies(int idScenario) async {
    //Appel DB réponses

    _replies = await ScenariosDatabase.instance.readAllReplies();
    return _replies.where((reply) => reply.idScenario == idScenario).toList();
  }

  /* getScenarioReplies renvoie la liste des relations Questions/Reponses 
  *  correspondantes a un id de scenario souhaité
  */
  Future<List<RelationQR>> initScenarioRelationsQR(int idScenario) async {
    //Appel DB relationsQR

    _relationsQR = await ScenariosDatabase.instance.readAllRelationsQR();
    return _relationsQR
        .where((relationQR) => relationQR.idScenario == idScenario)
        .toList();
  }

  //Init les variables de la DB
  Future<int> initScenarioVariables() async {
    //Appel DB variables
    print("call initScenarioVariables()");
    try {
      _variables = await ScenariosDatabase.instance.readAllVariables();
      print("Length _variables : ${_variables.length}");
      for (Variable V in _variables) {
        print("Variable : ${V.name} Value : ${V.value}");
      }
    } catch (e) {
      print("Error : table variables doesn't exist");
    }
    return 0;
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
      return 0;
    } else if (question.isOpenQuestion) {
      return 1;
    } else if (question.idNextQuestion == 0) {
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
    if (reply.idQuestion == 0) {
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

        //On modifie aussi cette variable dans la DB

        ScenariosDatabase.instance.updateVariable(_variables[i]);
      }
    }
    //Si la variable n'existe pas, on la créer
    if (!nameExist) {
      //On créer une nouvelle variable
      Variable newVariable = Variable(
        createdTime: DateTime.now(),
        name: name,
        value: value,
      );

      //On ajoute d'abord la variable en locale
      _variables.add(newVariable);

      //Puis on l'insère dans la DB

      ScenariosDatabase.instance.createVariable(newVariable);
    }
    //Si la langue est changée, la change en local aussi
    if (name == "lang") {
      lang = getLanguage();
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

  /* Renvoie la dernière question posée
  */
  Question getCurrentQuestion() {
    return getQuestionById(
        int.tryParse(getVariableByName("idCurrentQuestion")));
  }

  /* Renvoie la valeur d'une variable en fonction de son
  *  nom
  */
  String getVariableByName(name) {
    for (int i = 0; i < _variables.length; i++) {
      if (_variables[i].name == name) {
        return _variables[i].value;
      }
    }
    print("Error : variable $name not found");
    return null;
  }

  /* Renvoie la question correspondant a son id
  */
  Question getQuestionById(id) {
    for (int i = 0; i < _questions.length; i++) {
      if (_questions[i].id == id) {
        return _questions[i];
      }
    }
    print("Error : ID question not found");
    return null;
  }

  /* Renvoie la réponse correspondante a son id
  */
  Reply getReplyById(id) {
    for (int i = 0; i < _replies.length; i++) {
      if (_replies[i].id == id) {
        return _replies[i];
      }
    }
    print("Error : ID reply not found");
    return null;
  }

  /* Termine un scénario en passant les idCurrent à null
  */
  void endScenario() {
    setVariable("idCurrentScenario", '');
    setVariable("idCurrentQuestion", '');
    currentReplies = [];
    isClosedQuestion = false;
    isOpenQuestion = false;
  }

  /* Fonction pour contrinuer un scénario en cours.
  */
  void resumesOngoingScenario() {
    initScenarioVariables().then(
      (value) async {
        int idScenario = int.tryParse(getVariableByName("idCurrentScenario"));

        if (idScenario != 0 && idScenario != null) {
          //Permet de ne pas afficher la question 2 fois
          isResumeScenario = true;

          //On init le scenario
          _questions = await getScenarioQuestions(idScenario);
          _replies = await getScenarioReplies(idScenario);
          _relationsQR = await initScenarioRelationsQR(idScenario);

          //On récupère la question en cours
          Question currentQuestion = getCurrentQuestion();

          displayQuestion(currentQuestion);
        } else {
          print("resumesOngoingScenario : Pas de scénario en cours");
        }
      },
    );
  }

  /* Démarre un nouveau scénario
  */
  void initScenario(int id) async {
    //print("Init scénario");
    //On init le scenario avec son id
    _questions = await getScenarioQuestions(id);
    _replies = await getScenarioReplies(id);
    _relationsQR = await initScenarioRelationsQR(id);
    initScenarioVariables();

    //On récupère la première question
    Question firstQuestion = getFirstQuestion();

    if (firstQuestion != null) {
      //On met a jour les variables
      setVariable("idCurrentScenario", id.toString());
      setVariable("idCurrentQuestion", firstQuestion.id.toString());

      displayQuestion(firstQuestion);
    } else {
      print("Error : Scénario invalide");
    }
  }

  //Ajout d'un message en base
  void addMessage(textMessage, isSentByMeMessage) {
    //print("Add message");
    final message = Message(
      date: DateTime.now(),
      text: textMessage,
      isSentByMe: isSentByMeMessage,
    );

    MessageDatabase.instance.create(message); //Creer un message dans la BD
  }

  /* Retire les %% d'une chaine de caractère
  */
  String removePercent(String text) {
    return text.substring(2, text.length);
  }

  /* Renvoie une chaine de caractères avec une variable
  *  si nécessaire.
  */
  String replaceStringToVariable(String text) {
    //Créer un tableau de chaque mot
    List<String> textSplit = text.split(" ");
    for (var i = 0; i < textSplit.length; i++) {
      if (textSplit[i].contains("%%")) {
        textSplit[i] = getVariableByName(removePercent(textSplit[i]));
      }
    }
    return textSplit.join(" ");
  }

  /* Affiche a question actuelle 
  */
  void displayQuestion(Question question) {
    //print("Display question");
    //Update l'id de la question
    setVariable("idCurrentQuestion", question.id.toString());
    setVariable("idCurrentScenario", question.idScenario.toString());

    /*
    ScenariosDatabase.instance
        .readVariable('idCurrentScenario')
        .then((var_idScenario) {
      print("idCurrentScenario = ");
      print(var_idScenario.value);
    });*/

    //Ajoute les varialbes au texte si nécessaire
    String text;
    if (lang == 0) {
      text = replaceStringToVariable(question.textEN);
    } else if (lang == 1) {
      text = replaceStringToVariable(question.textFR);
    } else if (lang == 2) {
      text = replaceStringToVariable(question.textJP);
    } else {
      print("Error : lang $lang");
    }

    //On ne réaffiche pas le message lorsqu'on reprend un scénario en cours
    if (isResumeScenario) {
      isResumeScenario = false;
    } else {
      //Ajoute le message en base
      addMessage(text, false);
    }

    //Remet bool a false (défault)
    isClosedQuestion = false;
    isOpenQuestion = false;

    switch (typeOfQuestion(question)) {
      case 0: //fin
        {
          endScenario(); //Termine le scénario
        }
        break;
      case 1: //question ouverte
        {
          isOpenQuestion = true;
        }
        break;
      case 2: //question fermée
        {
          currentReplies = getRepliesByQuestion(question);
          isClosedQuestion = true;
          print("length currentReplies = ");
          print(currentReplies.length);
        }
        break;
      case 3: //robot continue
        {
          //wait 200ms pour pas que tout s'affiche d'un coup
          displayQuestion(getQuestionById(question.idNextQuestion));
          //setVariable("idCurrentQuestion", question.idNextQuestion.toString());
        }
        break;
      default:
    }
  }

  /* Affiche une réponse fermée et passe à la question suivante
  */
  void displayClosedReply(Reply reply) {
    //On ajoute le message
    if (lang == 0) {
      addMessage(reply.textEN, true);
    } else if (lang == 1) {
      addMessage(reply.textFR, true);
    } else if (lang == 2) {
      addMessage(reply.textJP, true);
    } else {
      print("Error lang $lang");
    }

    //On enregistre une variable si besoin
    if (reply.nameVariable != '') {
      if (lang == 0) {
        setVariable(reply.nameVariable, reply.textEN);
      } else if (lang == 1) {
        setVariable(reply.nameVariable, reply.textFR);
      } else if (lang == 2) {
        setVariable(reply.nameVariable, reply.textJP);
      } else {
        print("Error lang $lang");
      }
    }
    //On vérifie si c'est la dernière réplique
    if (replyIsEnd(reply)) {
      //On termine le scénario
      endScenario();
    } else {
      //On appelle la question suivante
      displayQuestion(getQuestionById(reply.idQuestion));
    }
  }

  /* Affiche une réponse ouverte et passe a la question suivante
  */
  void displayOpenReply(String text, Question question) {
    //On ajoute le message
    addMessage(text, true);
    //On enregistre une variable si besoin
    if (question.nameVariable != '') {
      setVariable(question.nameVariable, text);
    }
    //On vérifie si c'est la dernière réplique
    if (question.idNextQuestion == 0) {
      //On termine le scénario
      endScenario();
    } else {
      //On appelle la question suivante
      displayQuestion(getQuestionById(question.idNextQuestion));
    }
  }

  /* Fonction qui initialise un scénario aléatoire
  *  parmi les scénarios ayant une firstQuestion
  */
  Future<int> initRandomScenario() async {
    _questions = await ScenariosDatabase.instance.readAllQuestions();
    List<int> numbers = [];

    //On compte les scénarios ayant une firstQuestion
    for (int i = 0; i < _questions.length; i++) {
      if (_questions[i].isFirst && _questions[i].idScenario > 1) {
        numbers.add(_questions[i].idScenario);
      }
    }

    //On stop l'exécution
    if (numbers.isEmpty) {
      print("Error : random scénarios vide");
      return 1;
    }

    //On créer une variable random
    Random random = Random();
    int randomIndice = random.nextInt(numbers.length); //entre 0 et length

    print("Init scenario ${numbers[randomIndice]}");

    //On initialise le scénario correspondant a cet indice
    initScenario(numbers[randomIndice]);

    //Pas d'erreur
    return 0;
  }
}
