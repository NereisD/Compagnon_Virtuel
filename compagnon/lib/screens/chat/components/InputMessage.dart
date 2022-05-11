import 'package:compagnon/constants.dart';
import 'package:compagnon/flutter_flow/flutter_flow_icon_button.dart';
import 'package:compagnon/flutter_flow/flutter_flow_theme.dart';
import 'package:compagnon/models/Message.dart';
import 'package:compagnon/db/MessageDatabase.dart';
import 'package:compagnon/screens/chat/chat_body.dart';
import 'package:flutter/material.dart';

class InputMessage extends StatelessWidget {
  int iInput = 1;

  final _textController = TextEditingController();

  InputMessage({iInput});

  //Ajout d'un message en base
  void addMessage(textMessage, isSentByMeMessage) {
    final message = Message(
      date: DateTime.now(),
      text: textMessage,
      isSentByMe: isSentByMeMessage,
    );

    MessageDatabase.instance.create(message); //Creer un message dans la BD
    //Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (iInput == 1) {
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
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: 'Ecrivez un message la',
                ),
                //NewMessageWidget( //creer un style
                onSubmitted: (text) {
                  print('Bouton envoyer pressé ...');
                  addMessage(text, true);
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
              addMessage(_textController.text, true);
              _textController.text = "";
              RestartWidget.restartApp(context); //Reload la page de tchat
            },
          ),
        ],
      );
    } else if (iInput == 2) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {},
              child: const Text('Un homme'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {},
              child: const Text('Une femme'),
            ),
          ],
        ),
      );
    }
  }
}
