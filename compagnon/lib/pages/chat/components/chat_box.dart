import 'package:compagnon/constants.dart';
import 'package:compagnon/flutter_flow/flutter_flow_theme.dart';
import 'package:compagnon/models/Message.dart';
import 'package:compagnon/db/message_database.dart';
import 'package:compagnon/pages/chat/chat_body.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatBox extends StatefulWidget {
  ChatBox({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    print("call MyChatBox()");
    return MyChatBox();
  }
}

class MyChatBox extends State<ChatBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: FutureBuilder<List<Message>>(
        future: MessageDatabase.instance.readAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
          if (snapshot.hasData) {
            List<Message> messages = snapshot.data;
            /* debug messages
            for (int i = 0; i < messages.length; i++) {
              print(messages[i].id);
              print(messages[i].date);
              print(messages[i].text);
            }*/
            return GroupedListView<Message, DateTime>(
              padding: const EdgeInsets.all(8),
              reverse: false, //Avant : true
              sort: false, //Avant : pas ici (défault true)
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
                    color: Theme.of(context).secondaryHeaderColor,
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
              //itemCount: messages.length,
              itemBuilder: (context, Message message) => MessagePlacement(
                message: message,
                key: null,
              ),
            );
          } else {
            return Center(
              child: Text(
                noDataField[lang],
                style: TextStyle(fontSize: 20),
              ),
            );
          }
        },
      ),
    );
  }
}

// ignore: camel_case_types
class MessagePlacement extends StatefulWidget {
  MessagePlacement({Key key, this.message}) : super(key: key);
  final Message message;

  @override
  State<StatefulWidget> createState() {
    /*print(message.id);
    print(message.text);*/
    return MessageWidget();
  }
}

class MessageWidget extends State<MessagePlacement> {
  /* Widget message
  */
  @override
  Widget build(BuildContext context) {
    final message = widget.message;

    return Align(
      alignment:
          message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: message.isSentByMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /* Image de profil du robot
          */
          if (!message.isSentByMe)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 20, 0, 0),
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
          Card(
            elevation: 8, //L'ombre des messages
            child: InkWell(
              // InkWell Permet de cliquer sur un message
              child: Stack(
                children: [
                  //Le container du message
                  Container(
                    //Largeur max du widget message
                    constraints: const BoxConstraints(maxWidth: 250),
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
                //var keyValue = 2; // a changer !!!
                if (keyValue == 3) {
                  message.setIsLiked(!message.isLiked);
                  MessageDatabase.instance.update(message);
                  keyValue = 0;
                  setState(() {});
                } else if (keyValue == 4) {
                  message.setIsSecret(!message.isSecret);
                  MessageDatabase.instance.update(message);
                  keyValue = 0;
                  setState(() {});
                } else if (keyValue == 1) {
                  MessageDatabase.instance.delete(message.id);
                  keyValue = 0;
                  setState(() {});
                  RestartWidget.restartApp(context);
                  /*
              final provider =
                  Provider.of<TodosProvider>(context, listen: false);
              provider.reloadUI();*/
                }
              },
            ),
          ),
          /* Image de profil de l'utilisateur
          */
          if (message.isSentByMe)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 20, 0, 0),
              child: Container(
                width: 45,
                height: 45,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/femme2.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
