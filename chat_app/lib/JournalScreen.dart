import 'package:chat_app/class/Message.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import 'flutter_flow/flutter_flow_theme.dart';


class JournalScreen extends StatefulWidget{


  _JournalScreen createState() => _JournalScreen();


}
class _JournalScreen extends State<JournalScreen> {

  int id=0;

  int newMessageId() {
    return id = id + 1;
  }

  List<Message> messages = [
    Message(
      id: 1,
      text: 'Je vais bien aujourdhui',
      date: DateTime.now().subtract(Duration(days: 2, minutes: 5)),
      isSentByMe: true,
    ),
    Message(
      id: 1,
      text: 'Je vais bien aujourdhui',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 45)),
      isSentByMe: true,
    ),
  ].reversed.toList();


  @override
  Widget build(BuildContext context) {
    final _textController = TextEditingController();

    // TODO: implement build
    return Scaffold(
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
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .width,
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
      body: Column(
        children: [
          Expanded(
            child: GroupedListView<Message, DateTime>(
              padding: const EdgeInsets.all(8),
              reverse: true,
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              floatingHeader: true,
              elements: messages, // La liste des messages va ici
              // La liste des messages va ici
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

                  ),
                ),
              ),
            ),
          ),
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
                  id: 1,
                  // (On gardera juste le text après)
                  text: text + ' ',
                  date: DateTime.now(),
                  isSentByMe: true,
                );
                //Pour envoyer le message dans la liste des messages
                setState(() => messages.add(message));

                //Pour envoyer le message dans la liste des messages
              },
              //), //fin du widget message
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

