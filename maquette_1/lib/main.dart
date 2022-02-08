//import 'dart:html';

import 'package:timeago/timeago.dart';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  var info = "Ceci est une info";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Compagnon virtuel',
      home: HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  TextEditingController textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: deprecated_member_use
  var bullesDialogue = List.generate(1, (_) => List(6));

  // ignore: deprecated_member_use
  var scenarioRobot = List.generate(10, (_) => List(3));

  // ignore: deprecated_member_use
  var scenarioUser = List.generate(12, (_) => List(3));

  // ignore: deprecated_member_use
  var dimensionsBulles = List.generate(3, (_) => List(3));

  /* iRobot permet de trouver l'indice dans le scénario du Robot */
  int iRobot = 0;

  /* pxReponses permet de définir la taille du widget réponses en px */
  double pxReponses;

  /* typeBulle permet de définir la taille d'une bulle de dialogue.
  Type 1 : la plus petite
  Type 2 : intermédaire
  Type 3 : la plus grosse */
  int typeBulle;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();

    scenarioRobot = initialiseScenarioRobot();
    scenarioUser = initialiseScenarioUser();
    dimensionsBulles = initialiseDimensionsBulles();

    pxReponses = scenarioRobot[0][2].length.toDouble() * 60 + 20;
    typeBulle = 3;

    //initialisation des bulles de dialogues
    //colonne 0 : ID_bulle,
    //colonne 1 : isUser (0 = robot ou 1 = user),
    //colonne 2 : text,
    //colonne 3 : time (en string ?)
    bullesDialogue[0][0] = 0;
    bullesDialogue[0][1] = 0;
    bullesDialogue[0][2] = scenarioRobot[0][1];
    bullesDialogue[0][3] =
        "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, "0")}";
    bullesDialogue[0][4] = 2;
    bullesDialogue[0][5] = false;

    // ignore: avoid_print
    print("bulles0 = " + bullesDialogue.toString());
  }

  List<List<dynamic>> initialiseDimensionsBulles() {
    dimensionsBulles[0][0] = 0; //type de bulle
    dimensionsBulles[0][1] = 50; //height
    dimensionsBulles[0][2] = 0.3; //width
    dimensionsBulles[1][0] = 1;
    dimensionsBulles[1][1] = 50;
    dimensionsBulles[1][2] = 0.6;
    dimensionsBulles[2][0] = 2;
    dimensionsBulles[2][1] = 70;
    dimensionsBulles[2][2] = 0.8;

    return dimensionsBulles;
  }

  List<List<dynamic>> initialiseScenarioRobot() {
    /* Création d'un scénario du robot */
    scenarioRobot[0][0] = 0;
    scenarioRobot[0][1] = "Bonjour, je m'appelle Bob. Aimez-vous les bananes ?";
    scenarioRobot[0][2] = [0, 1];
    scenarioRobot[1][0] = 1;
    scenarioRobot[1][1] = "Moi aussi ! Et les abricots ? ";
    scenarioRobot[1][2] = [6, 7];
    scenarioRobot[2][0] = 2;
    scenarioRobot[2][1] =
        "Si vous n'aimez pas les bananes, quel fruit préférez vous ? ";
    scenarioRobot[2][2] = [2, 3, 4, 5];
    scenarioRobot[3][0] = 3;
    scenarioRobot[3][1] =
        "Si vous n'aimez pas les abricots, quel fruit préférez vous ? ";
    scenarioRobot[3][2] = [2, 4, 5];
    scenarioRobot[4][0] = 4;
    scenarioRobot[4][1] = "Les kiwis sont bons";
    scenarioRobot[4][2] = [11];
    scenarioRobot[5][0] = 5;
    scenarioRobot[5][1] =
        "J'ai une recette de tarte aux abricots, si vous voulez";
    scenarioRobot[5][2] = [8, 9];
    scenarioRobot[6][0] = 6;
    scenarioRobot[6][1] =
        "J'ai une recette de glace aux poires, si vous voulez";
    scenarioRobot[6][2] = [8, 9];
    scenarioRobot[7][0] = 7;
    scenarioRobot[7][1] = "J'ai une recette de glace, si vous voulez";
    scenarioRobot[7][2] = [8, 9];
    scenarioRobot[8][0] = 8;
    scenarioRobot[8][1] = "Tenez, au revoir ! ";
    scenarioRobot[8][2] = [10];
    scenarioRobot[9][0] = 9;
    scenarioRobot[9][1] =
        "Tant pis, au revoir ! Ce fut un plaisir de vous, rencontrer. Et c'est un long message ! Oui vraiment long ? Ou pas. Peut etre bien que si en fait.";
    scenarioRobot[9][2] = [10];

    return scenarioRobot;
  }

  List<List<dynamic>> initialiseScenarioUser() {
    /* Création d'un scénario de l'utilisateur */
    scenarioUser[0][0] = 0;
    scenarioUser[0][1] = "Oui j'aime les bananes";
    scenarioUser[0][2] = 1;
    scenarioUser[1][0] = 1;
    scenarioUser[1][1] = "Non je n'aime pas les bananes";
    scenarioUser[1][2] = 2;
    scenarioUser[2][0] = 2;
    scenarioUser[2][1] = "Je préfère les kiwis";
    scenarioUser[2][2] = 4;
    scenarioUser[3][0] = 3;
    scenarioUser[3][1] = "Je préfère les abricots";
    scenarioUser[3][2] = 5;
    scenarioUser[4][0] = 4;
    scenarioUser[4][1] = "Je préfère les poires";
    scenarioUser[4][2] = 6;
    scenarioUser[5][0] = 5;
    scenarioUser[5][1] = "Je n'aime aucun fruit";
    scenarioUser[5][2] = 7;
    scenarioUser[6][0] = 6;
    scenarioUser[6][1] = "Oui j'aime les abricots";
    scenarioUser[6][2] = 5;
    scenarioUser[7][0] = 7;
    scenarioUser[7][1] = "Non je n'aime pas les abricots";
    scenarioUser[7][2] = 3;
    scenarioUser[8][0] = 8;
    scenarioUser[8][1] = "Donnez moi la recette";
    scenarioUser[8][2] = 8;
    scenarioUser[9][0] = 9;
    scenarioUser[9][1] = "Non merci";
    scenarioUser[9][2] = 9;
    scenarioUser[10][0] = 10;
    scenarioUser[10][1] = "Au revoir ! ";
    scenarioUser[10][2] = 0; //ici -1 mais pour boucler on laisse 0
    scenarioUser[11][0] = 11;
    scenarioUser[11][1] = "Je m'en vais manger des kiwis ";
    scenarioUser[11][2] = -1;

    return scenarioUser;
  }

  void creerBulle(String message, int isUser) {
    if (message.length < 15) {
      typeBulle = 0;
    } else if (message.length < 30) {
      typeBulle = 1;
    } else {
      typeBulle = 2;
    }
    print("message length = " + message.length.toString());
    print("typeBulle = " + typeBulle.toString());

    /* Augmentation de la taille du tableau */
    int idBulle = bullesDialogue.length;
    bullesDialogue.length = bullesDialogue.length + 1;

    /* Attribution d'une nouvelle bulle au tableau */
    var bulle = [
      idBulle,
      isUser,
      message,
      "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, "0")}",
      typeBulle,
      false
    ];
    bullesDialogue[idBulle] = bulle;
    print("bullesDialogue[" + idBulle.toString() + "] = " + bulle.toString());
  }

  //Fonction pour ajouter une bulle de dialogue
  void ajoutBulle(String message, int isUser) {
    setState(() {
      //value = $m;
      print("-------- Début ajoutBulle --------");

      int MAX = 70;
      bool estRentreDansLeWhile = false;
      bool stopWhile = false;
      var splittedMessage = message;
      while (message.length > MAX && stopWhile == false) {
        splittedMessage = '';
        estRentreDansLeWhile = true;

        if (message.contains('?') && message.indexOf('?') < MAX) {
          splittedMessage = message.substring(0, message.indexOf('?') + 1);
          message = message.substring(message.indexOf('?') + 1, message.length);
        } else if (message.contains('!') && message.indexOf('!') < MAX) {
          splittedMessage = message.substring(0, message.indexOf('!') + 1);
          message = message.substring(message.indexOf('!') + 1, message.length);
        } else if (message.contains('.') && message.indexOf('.') < MAX) {
          splittedMessage = message.substring(0, message.indexOf('.') + 1);
          message = message.substring(message.indexOf('.') + 1, message.length);
        } else if (message.contains(',') && message.indexOf(',') < MAX) {
          splittedMessage = message.substring(0, message.indexOf(',') + 1);
          message = message.substring(message.indexOf(',') + 1, message.length);
        } else {
          stopWhile = true;
          splittedMessage = message;
        }
        //print("splittedMessage = " + splittedMessage);
        //print("message = " + message);

        creerBulle(splittedMessage, isUser);
      }

      if (estRentreDansLeWhile == false || message != splittedMessage) {
        creerBulle(message, isUser);
      }

      /* Attribution de la taille du widget des boutons */
      pxReponses = scenarioRobot[iRobot][2].length.toDouble() * 60 + 10;

      print("-------- Fin ajoutBulle --------");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.primaryColor,
        automaticallyImplyLeading: true,
        title: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/robot.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 0; i < bullesDialogue.length; i++)
                      if (bullesDialogue[i][1] == 0)
                        /* Bulle de dialogue du robot */
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                              child: Container(
                                width: 45,
                                height: 45,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/images/robot.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width *
                                    dimensionsBulles[bullesDialogue[i][4]][2],
                                height: dimensionsBulles[bullesDialogue[i][4]]
                                        [1]
                                    .toDouble(),
                                decoration: BoxDecoration(),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: Image.asset(
                                            'assets/images/bulle_gauche_' +
                                                bullesDialogue[i][4]
                                                    .toString() +
                                                '.png',
                                          ).image,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20, 10, 10, 10),
                                        child: Text(
                                          bullesDialogue[i][2].toString(),
                                          //"${bullesDialogue[i][2].hour}:${bullesDialogue[i][2].minute.toString().padLeft(2, "0")}",
                                          style: FlutterFlowTheme.bodyText1
                                              .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(1, 1),
                                      child: Container(
                                        width: 100,
                                        height: 20,
                                        decoration: BoxDecoration(),
                                        child: Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            bullesDialogue[i][3].toString(),
                                            style: FlutterFlowTheme.bodyText1
                                                .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (bullesDialogue[i][5])
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.95, 0.10),
                                        child: Icon(
                                          Icons.favorite,
                                          //color: FlutterFlowTheme.primaryColor,
                                          color: Colors.red.shade900,
                                          size: 20,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        /* Bulle de dialogue de l'utilisateur */
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width *
                                    dimensionsBulles[bullesDialogue[i][4]][2],
                                height: dimensionsBulles[bullesDialogue[i][4]]
                                        [1]
                                    .toDouble(),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: Image.asset(
                                            'assets/images/bulle_droite_' +
                                                bullesDialogue[i][4]
                                                    .toString() +
                                                '.png',
                                          ).image,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20, 10, 10, 10),
                                        child: Text(
                                          bullesDialogue[i][2].toString(),
                                          style: FlutterFlowTheme.bodyText1
                                              .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(1, 1),
                                      child: Container(
                                        width: 100,
                                        height: 20,
                                        decoration: BoxDecoration(),
                                        child: Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            bullesDialogue[i][3].toString(),
                                            style: FlutterFlowTheme.bodyText1
                                                .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (bullesDialogue[i][5])
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.90, 0.30),
                                        child: Icon(
                                          Icons.favorite,
                                          //color: FlutterFlowTheme.primaryColor,
                                          color: Colors.yellow.shade700,
                                          size: 20,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                              child: Container(
                                width: 45,
                                height: 45,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/images/femme2.png',
                                ),
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFEEEEEE),
                        )
                      ],
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child:
                        /* La raw du text fild commence ici */
                        Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 0, 0),
                            child: TextFormField(
                              controller: textController,
                              obscureText: false,
                              /* enabled permet de griser le textfield */
                              enabled: true,
                              decoration: InputDecoration(
                                hintText: 'Écrire un message',
                                hintStyle: FlutterFlowTheme.bodyText1.override(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.bodyText1.override(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30,
                          borderWidth: 1,
                          buttonSize: 60,
                          icon: const Icon(
                            Icons.send,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            /* On récupère la valeur du text et on la vide */
                            print('le text : ' + textController.text);

                            ajoutBulle(textController.text, 1);
                            textController.text = "";

                            print('Bouton envoyer pressé ...');
                          },
                        ),
                      ],
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: pxReponses,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.primaryColor,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (iRobot >= 0)
                        for (int i = 0;
                            i < scenarioRobot[iRobot][2].length;
                            i++)
                          FFButtonWidget(
                            onPressed: () {
                              ajoutBulle(
                                  scenarioUser[scenarioRobot[iRobot][2][i]][1]
                                      .toString(),
                                  1);
                              /* indice dans le scénario robot :
                            scenarioUser[scenarioRobot[0][2][i]][2] */
                              iRobot =
                                  scenarioUser[scenarioRobot[iRobot][2][i]][2];
                              ajoutBulle(scenarioRobot[iRobot][1], 0);
                              print('Button1 pressed ...');
                              print('Nouveau iRobot = $iRobot');
                            },
                            text: scenarioUser[scenarioRobot[iRobot][2][i]][1]
                                .toString(),
                            /* indice dans le scénario user :
                          scenarioRobot[0][2][i],*/
                            options: FFButtonOptions(
                              width: 300,
                              height: 30,
                              color: Colors.white,
                              textStyle: FlutterFlowTheme.subtitle2.override(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.tertiaryColor,
                                width: 1,
                              ),
                              borderRadius: 12,
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional(0, 58.48),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    borderWidth: 1,
                    buttonSize: 60,
                    icon: FaIcon(
                      FontAwesomeIcons.cog,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      print('Icon_reglages pressed ...');
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    borderWidth: 1,
                    buttonSize: 60,
                    icon: FaIcon(
                      FontAwesomeIcons.question,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      print('Icon_question pressed ...');
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    borderWidth: 1,
                    buttonSize: 60,
                    icon: FaIcon(
                      FontAwesomeIcons.book,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      print('Icon_journal pressed ...');
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    borderWidth: 1,
                    buttonSize: 60,
                    icon: FaIcon(
                      FontAwesomeIcons.gamepad,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      print('Icon_game pressed ...');
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    borderWidth: 1,
                    buttonSize: 60,
                    icon: FaIcon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      print('Icon_like pressed ...');
                      //Ici on passe le bool du like à son inverse (indice [5])
                      bullesDialogue[bullesDialogue.length - 1][5] =
                          !bullesDialogue[bullesDialogue.length - 1][5];
                      //Debug print pour voir le bool s'inverser
                      /*print('bullesDialogue[' +
                          bullesDialogue.length.toString() +
                          '][5] = ' +
                          bullesDialogue[bullesDialogue.length - 1][5]
                              .toString());*/
                      setState(() {
                        //permet de reload l'UI même si c'est vide
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
