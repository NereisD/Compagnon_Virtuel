import 'package:chat_app/class/ManageDatabase.dart';
import 'package:chat_app/class/Message.dart';
import 'package:chat_app/class/Statement.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import 'flutter_flow/flutter_flow_icon_button.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_widgets.dart';
import 'package:chat_app/JournalScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compagnon virtuel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Menu principal'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MainPageState();
}

class _MainPageState extends State<MyHomePage> {
  //permet de controller le contenu du texte du TextField (pour le vider)
  final _textController = TextEditingController();

  /* La valeur des boutons :
  * 0 : aucun
  * 1 : like
  * 2 : secret
  */
  int keyValue = 0;

  //Renvoie l'id incrémenté du dernier message
  int newMessageId() {
    return messages[messages.length - 1].id + 1;
  }

  List<Message> messages = [
    Message(
      id: 3,
      text: '(Historique) message robot 3',
      date: DateTime.now().subtract(Duration(days: 2, minutes: 1)),
      isSentByMe: false,
    ),
    Message(
      id: 2,
      text: '(Historique) message utilisateur 2',
      date: DateTime.now().subtract(Duration(days: 2, minutes: 2)),
      isSentByMe: true,
    ),
    Message(
      id: 1,
      text: '(Historique) message robot 1',
      date: DateTime.now().subtract(Duration(days: 2, minutes: 5)),
      isSentByMe: false,
    ),
  ].reversed.toList();

  List<Statement> scenario = [
    Statement(
      id: 1,
      text:
          'Bonjour je m\'appelle Bob, je suis votre nouveau compagnon virtuel.',
      isUser: false,
      idAnswers: [2],
    ),
    Statement(
      id: 2,
      text: 'Bonjour Bob !',
      isUser: true,
      idAnswers: [3],
    ),
    Statement(
      id: 3,
      text: 'Quel fruit préférez vous ?',
      isUser: false,
      idAnswers: [4, 5, 6],
    ),
    Statement(
      id: 4,
      text: 'Les poires',
      isUser: true,
      idAnswers: [7],
    ),
    Statement(
      id: 5,
      text: 'Les abricots',
      isUser: true,
      idAnswers: [7],
    ),
    Statement(
      id: 6,
      text: 'Je n\'aime pas les fruits',
      isUser: true,
      idAnswers: [9],
    ),
    Statement(
      id: 7,
      text: 'Je ne peux pas en manger puisque je suis un robot',
      isUser: false,
      idAnswers: [8],
    ),
    Statement(
      id: 8,
      text: 'Mais je me demande quel goût ça a ...',
      isUser: false,
      idAnswers: [1],
    ),
    Statement(
      id: 9,
      text: 'Tant pis au revoir !',
      isUser: false,
      idAnswers: [1],
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        /* ------ AppBar avec l'image du robot ------ */
        appBar: AppBar(
          //backgroundColor: FlutterFlowTheme.primaryColor,
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
        body: FutureBuilder<List<Message>>(
          future : ManageDatabase.instance.messages(),
          builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot){
            if (snapshot.hasData){
              List<Message> Recipes = snapshot.data;
              return
            }
          }
          children: [
            //Pour mettre le textField en bas
            Expanded(
              child: GroupedListView<Message, DateTime>(
                padding: const EdgeInsets.all(8),
                reverse: true,
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                floatingHeader: true,
                elements: messages, // La liste des messages va ici
                groupBy: (message) => DateTime(
                  //On regroupe les messages d'un même jour ensemble
                  message.date.year,
                  message.date.month,
                  message.date.day,
                ),
                /* Un header pour chaque groupe de message 
              * (un groupe étant un jour)
              * C'est un Card widget avec la date du jour
              */
                groupHeaderBuilder: (Message message) => SizedBox(
                  height: 40,
                  child: Center(
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          //Nécessite la librairie intl
                          DateFormat.yMMMd().format(message.date),
                          //Style du widget date (le fond bleu)
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                /* On créer les messages dans le itemBuilder
                * L'alignement permet d'afficher à droite ou à gauche les éléments
                */
                itemBuilder: (context, Message message) =>
                    //MessageBubble(message: message), //Remplace tout le Align et child: Card(...)
                    Align(
                  alignment: message.isSentByMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Card(
                    elevation: 8, //L'ombre des messages
                    child: InkWell(
                      // InkWell Permet de cliquer sur un message
                      child: Stack(
                        children: [
                          //Le container du message
                          Container(
                            color: message.isSentByMe
                                ? Colors.lightGreen[100]
                                : Colors.blueGrey[50],
                            child: Padding(
                              padding: const EdgeInsets.all(14), //Le contour
                              child: Text(
                                message.text,
                                //Ici on modifie le style du texte des bulles
                                style: FlutterFlowTheme.bodyText1.override(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          /* ------ Widget de l'heure ------ */
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                DateFormat.Hm().format(message.date),
                                style: FlutterFlowTheme.bodyText1.override(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          /* ------ Widget du like ------ 
                          * Positioned.fill permet de prendre toute 
                          * tla taille disponible
                          */
                          if (message.isLiked)
                            const Positioned.fill(
                              child: Align(
                                alignment: AlignmentDirectional(0.80, 1.00),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent,
                                  size: 18,
                                ),
                              ),
                            ),
                          /* ------ Widget du secret ------ */
                          if (message.isSecret)
                            const Positioned.fill(
                              child: Align(
                                alignment: AlignmentDirectional(0.00, -1.00),
                                child: Icon(
                                  Icons.vpn_key,
                                  color: Colors.orangeAccent,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),

                      // Gère l'event de cliquer sur le message
                      onTap: () {
                        print("Id du message : " + message.id.toString());
                        if (keyValue == 1) {
                          message.setIsLiked(!message.isLiked);
                          keyValue = 0;
                          setState(() {});
                        } else if (keyValue == 2) {
                          message.setIsSecret(!message.isSecret);
                          keyValue = 0;
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (1 == 1) // Condition : si c'est une question ouverte
              /* ------ Widget pour écrire un message ------ */
              Container(
                color: Colors.grey.shade300,
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'Ecrivez un message ici',
                  ),
                  //NewMessageWidget( //creer un style
                  onSubmitted: (text) {
                    print('Bouton envoyer pressé ...');
                    _textController.text = "";
                    final message = Message(
                      id: newMessageId(),
                      // (On gardera juste le text après)
                      text: text + ' ' + newMessageId().toString(),
                      date: DateTime.now(),
                      isSentByMe: true,
                    );
                    //Pour envoyer le message dans la liste des messages
                    setState(() => messages.add(message));
                  },
                  //), //fin du widget message
                ),
              )
            else //Condition : Si c'est une question fermée
              /* ------ Widget pour le choix d'une réponse ------ */
              Container(
                width: MediaQuery.of(context).size.width,
                height: 140,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.primaryColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FFButtonWidget(
                      onPressed: () {
                        print('Button1 pressed ...');
                      },
                      text: 'Un homme',
                      options: FFButtonOptions(
                        width: 250,
                        height: 35,
                        color: Colors.white,
                        textStyle: FlutterFlowTheme.subtitle2.override(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.tertiaryColor,
                          width: 1,
                        ),
                        borderRadius: 12,
                      ),
                    ),
                    FFButtonWidget(
                      onPressed: () {
                        print('Button2 pressed ...');
                      },
                      text: 'Une femme',
                      options: FFButtonOptions(
                        width: 250,
                        height: 35,
                        color: Colors.white,
                        textStyle: FlutterFlowTheme.subtitle2.override(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: 12,
                      ),
                    ),
                  ],
                ),
              ),
            /* ------ Les boutons en pied de page ------ */
            Container(
              color: Colors.teal,
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
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> JournalScreen()));
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    borderWidth: 1,
                    buttonSize: 60,
                    icon: Icon(
                      Icons.vpn_key,
                      color: keyValue == 2 ? Colors.orangeAccent : Colors.black,
                      size: 32,
                    ),
                    onPressed: () {
                      print('Icon_secret pressed ...');
                      if (keyValue != 2) {
                        keyValue = 2;
                      } else {
                        keyValue = 0;
                      }
                      setState(() {
                        //permet de reload l'UI même si c'est vide
                      });
                    },
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    borderWidth: 1,
                    buttonSize: 60,
                    icon: FaIcon(
                      FontAwesomeIcons.solidHeart,
                      color: keyValue == 1 ? Colors.redAccent : Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      print('Icon_like pressed ...');
                      if (keyValue != 1) {
                        keyValue = 1;
                      } else {
                        keyValue = 0;
                      }
                      setState(() {
                        //permet de reload l'UI même si c'est vide
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );
}


