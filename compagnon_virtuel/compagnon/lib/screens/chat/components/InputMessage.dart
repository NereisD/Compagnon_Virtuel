import 'package:compagnon/models/Message.dart';
import 'package:compagnon/models/MessageDatabase.dart';
import 'package:flutter/material.dart';


class InputMessage extends StatelessWidget {
 int iInput = 1;

  final _textController = TextEditingController();

  InputMessage({iInput});


    @override
    Widget build(BuildContext context) {
      if (iInput == 1) {
        return Container(
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
                      final messgaeinput = Message(1,text, DateTime.now().toString(), true, false, false);
                      MessageDatabase.instance.insertMessage(messgaeinput);
                    },
                  ),
                );
      } else {
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