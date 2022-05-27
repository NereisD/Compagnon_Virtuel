import 'package:compagnon/flutter_flow/flutter_flow_icon_button.dart';
import 'package:compagnon/models/Message.dart';
import 'package:compagnon/db/message_database.dart';
import 'package:compagnon/models/question.dart';
import 'package:compagnon/models/reply.dart';
import 'package:compagnon/pages/chat/chat_body.dart';
import 'package:compagnon/values/languages.dart';
import 'package:flutter/material.dart';
import 'package:compagnon/values/constants.dart';
import 'package:provider/provider.dart';

class InputMessage extends StatelessWidget {
  /*
    final provider = Provider.of<ScenarioProvider>(context);

    Question question_test = provider.getFirstQuestion();
    print(question_test.textFR);*/

  int iInput = 2;
  final _textController = TextEditingController();

  var input;

  /*
  //Ajout d'un message en base
  void addMessage(textMessage, isSentByMeMessage) {
    final message = Message(
      date: DateTime.now(),
      text: textMessage,
      isSentByMe: isSentByMeMessage,
    );

    /*
    Question test = currentScenario.getFirstQuestion();
    print("TextFR de la première réplique : ");
    print(test.textFR);*/

    MessageDatabase.instance.create(message); //Creer un message dans la BD
    //Navigator.of(context).pop();
  }*/

  /* permet de reload l'UI apres le temps d'accès à la BD
  */
  Future reloadUI(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 200));
    print("restart widget");
    RestartWidget.restartApp(context);
  }

  @override
  Widget build(BuildContext context) {
    if (currentScenario.isOpenQuestion) {
      return Row(
        children: [
          /* Container input message
          */
          Expanded(
            child: Container(
              color: Colors.grey.shade300,
              height: 50,
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: writeTextField[lang],
                ),
                //NewMessageWidget( //creer un style
                onSubmitted: (text) {
                  print('Bouton envoyer pressé ...');
                  //currentScenario.addMessage(text, true);

                  //On envoie la réponse écrite
                  currentScenario.displayOpenReply(
                      text, currentScenario.getCurrentQuestion());

                  _textController.text = "";
                  RestartWidget.restartApp(context); //Reload la page de tchat
                },
              ),
            ),
          ),
          /* Bouton envoyer
          */
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.send,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              print('IconButton pressed ...');
              //currentScenario.addMessage(_textController.text, true);

              //On envoie la réponse écrite
              currentScenario.displayOpenReply(
                  _textController.text, currentScenario.getCurrentQuestion());
              _textController.text = "";
              RestartWidget.restartApp(context); //Reload la page de tchat
            },
          ),
        ],
      );
    } else if (currentScenario.isClosedQuestion) {
      //Container des réponses fermées
      return Container(
        width: MediaQuery.of(context).size.width,
        //height: 140,
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: kLighterBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          //Pour chaque réponse à la question posée
          children: <Widget>[
            for (Reply reply in currentScenario.currentReplies)
              Container(
                margin: const EdgeInsets.all(6.0),
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: kSecondaryColor,
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    //padding: const EdgeInsets.all(10.0),
                    primary: Colors.white,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    print(reply.textFR);
                    currentScenario.displayClosedReply(reply);
                    RestartWidget.restartApp(context); //Reload la page de tchat
                  },
                  child: lang == 0
                      ? Text(reply.textEN)
                      : lang == 1
                          ? Text(reply.textFR)
                          : Text(reply.textJP),
                ),
              ),
          ],

          /*
          children: [
            Container(
              margin: const EdgeInsets.all(6.0),
              width: MediaQuery.of(context).size.width,
              height: 40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: kSecondaryColor,
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  //padding: const EdgeInsets.all(10.0),
                  primary: Colors.white,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {},
                child: const Text('Un homme'),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6.0),
              width: MediaQuery.of(context).size.width,
              height: 40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: kSecondaryColor,
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  //padding: const EdgeInsets.all(10.0),
                  primary: Colors.white,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {},
                child: const Text('Une femme'),
              ),
            ),
          ],*/
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        //height: 140,
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: kLighterBackgroundColor,
        ),
        child: Container(
          margin: const EdgeInsets.all(6.0),
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: kSecondaryColor,
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              //padding: const EdgeInsets.all(10.0),
              primary: Colors.white,
              textStyle: const TextStyle(fontSize: 18),
            ),
            onPressed: () {
              currentScenario.addMessage(helloField[lang], true);
              currentScenario.initScenario(2); // ICI lancer un scénario random

              //RestartWidget.restartApp(context); //Reload la page de tchat
              reloadUI(context);
            },
            child: Text(waveButton[lang]),
          ),
        ),
      );
    }
  }
}
