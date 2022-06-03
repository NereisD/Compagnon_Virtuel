import 'package:compagnon/db/import_json.dart';
import 'package:compagnon/db/scenarios_database.dart';
import 'package:compagnon/pages/home_page.dart';
import 'package:compagnon/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenPage extends StatelessWidget {
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
              //reloadUI(context, true);
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
                  //reloadUI(context, false);
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
    return SplashScreen(
      seconds: 8,
      navigateAfterSeconds: HomeScreen(),
      backgroundColor: Colors.teal,
      title: const Text(
        'Compagnon',
        textScaleFactor: 2,
      ),
      image: Image.asset(
        'assets/images/robot.png',
        fit: BoxFit.cover,
      ),
      loadingText: Text("Loading"),
      photoSize: 110.0,
      loaderColor: Colors.white,
    );
  }
}
