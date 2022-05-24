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
  Future reloadUI(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 800));
    print("restart widget");
    RestartWidget.restartApp(context);
  }

  /* Fonction qui permet de lancer le scénario d'init ou de reprendre 
  *  un scénario en cours
  */
  void initLifeCycle(BuildContext context) {
    print("call initLifeCycle");

    //Get la variable idCurrentScenario depuis les bases
    ScenariosDatabase.instance.readVariable('isInitialized').then(
      (variable) {
        //Si null, on démarre le 1er scénario
        if (variable == null) {
          //reloadInit = false;
          importScenarios(true).then(
            (value) {
              print("Init welcome scenario (1)");
              currentScenario.setVariable('isInitialized', '1');
              currentScenario.initScenario(1); //id 1 = scénario de bienvenue
              reloadUI(context);
            },
          );
        } else {
          //currentScenario.initScenarioVariables();
          //On lit l'id du scénario
          ScenariosDatabase.instance.readVariable('idCurrentScenario').then(
            (variableID) {
              if (variableID != null) {
                //print("idCurrentScenario = ${variableID.value}");
                //Si il est non vide, on reprend le scénario en cours
                if (variableID.value != '') {
                  //reloadInit = false;
                  print("Resume ongoing scénario");
                  //Fonction qui reprend le scénario
                  currentScenario.resumesOngoingScenario();
                  reloadUI(context);
                }
              } else {
                print("Else : idCurrentScenario = ${variableID.value}");
              }
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (reloadInit) {
      reloadInit = false;
      initLifeCycle(context);
    }
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
