import 'package:compagnon/constants.dart';
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
  /*
  Future<String> getLocalPath() async {
  final directory = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  return directory;
}*/

  @override
  Widget build(BuildContext context) {
    /* Fonction qui attend qu'un message soit posté pour relad l'UI
    */
    /*
    Future waitLoadingMessage() async {
      await Future.delayed(const Duration(seconds: 1), () {
        print("Restarting ChatApp ...");
        RestartWidget.restartApp(context);
      });
    }

    print("(ChatBody) loadingMessage = ");
    print(loadingMessage);
    if (loadingMessage) {
      //waitLoadingMessage();
    }*/

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: ChatBox(),
        ),
        InputMessage(iInput: 1),
      ],
    );
  }
}
