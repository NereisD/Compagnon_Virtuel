import 'package:compagnon/db/import_json.dart';
import 'package:compagnon/db/scenarios_database.dart';
import 'package:compagnon/values/constants.dart';
import 'package:compagnon/pages/chat/components/Interact_Message.dart';
import 'package:compagnon/pages/chat/components/input_message.dart';
import 'package:compagnon/pages/chat/components/chat_box.dart';
import 'package:flutter/material.dart';

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: ChatBody(),
    );
  }
}

class ChatBody extends StatelessWidget {
  /* permet de reload l'UI apres le temps d'accès à la BD
  */
  Future reloadUI(BuildContext context, bool isFirstStart) async {
    if (isFirstStart) {
      await Future.delayed(const Duration(milliseconds: 8000));
    } else {
      await Future.delayed(const Duration(milliseconds: 600));
    }
    print("restart widget");
    RestartWidget.restartApp(context);
  }

  @override
  Widget build(BuildContext context) {

    /* Taille de l'écran en largeur selon 3 tailles : 
     * petit : <400 - (fontSize 14) - image icon 45px
     * moyen : <800 - (fontSize 16) - image icon 55px
     * grand : >=800 - (fontSize 18) - image icon 65px
     */
    screenWidth = MediaQuery.of(context).size.width;
    print("screenWidth = " + screenWidth.toString());

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: ChatBox(),
        ),
        InputMessage(),
        interactMessage(),
      ],
    );
  }
}
