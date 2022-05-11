import 'package:compagnon/constants.dart';
import 'package:compagnon/flutter_flow/flutter_flow_theme.dart';
import 'package:compagnon/models/Message.dart';
import 'package:compagnon/db/MessageDatabase.dart';
import 'package:compagnon/providers/todos.dart';
import 'package:compagnon/screens/chat/chat_body.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class chatBox extends StatefulWidget {
  chatBox({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    print("call MychatBox()");
    return MychatBox();
  }
}

class MychatBox extends State<chatBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: FutureBuilder<List<Message>>(
        future: MessageDatabase.instance.readAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
          if (snapshot.hasData) {
            List<Message> messages = snapshot.data;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) => messagePlacement(
                message: messages[index],
                key: null,
              ),
            );
          } else {
            return const Center(
              child: Text(
                "No Data",
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
class messagePlacement extends StatefulWidget {
  messagePlacement({Key key, this.message}) : super(key: key);
  final Message message;
  @override
  State<StatefulWidget> createState() {
    return MessageWidget();
  }
}

class MessageWidget extends State<messagePlacement> {
  /* Widget message
  */
  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    return Align(
      alignment:
          message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
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
    );
  }
}
