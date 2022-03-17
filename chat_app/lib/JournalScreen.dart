import 'package:flutter/material.dart';


class JournalScreen extends StatelessWidget{
  const JournalScreen({Key key}) : super(key: key);

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
      body: Column(
        children: [
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