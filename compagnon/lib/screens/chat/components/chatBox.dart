import 'package:compagnon/constants.dart';
import 'package:compagnon/models/Message.dart';
import 'package:compagnon/db/MessageDatabase.dart';
import 'package:flutter/material.dart';





class chatBox extends StatefulWidget {

    chatBox({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
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

    //  ListView.builder(
    //       itemCount: MessageDatabase.instance.defaultMessages.length,
    //       itemBuilder: (context, index) => messagePlacement(message: MessageDatabase.instance.defaultMessages[index],)
    //       ) ,
    //     );
  }
}





class messagePlacement extends StatefulWidget {

  messagePlacement( {Key key, this.message}) : super(key: key);
  final Message message; 
  @override
  State<StatefulWidget> createState() {
    return MymessagePlacement();
  }
}

class MymessagePlacement extends State<messagePlacement> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment: widget.message.isSentByMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!widget.message.isSentByMe) ...{
            CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/images/robot.png")),
          },
          SizedBox(width: kDefaultPadding),
          Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 0.75,
                vertical: kDefaultPadding / 2,
              ),
              decoration: BoxDecoration(
                  color: widget.message.isSentByMe ? Colors.teal : Colors.blueAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                widget.message.text,
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}
