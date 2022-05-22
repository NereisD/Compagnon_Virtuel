import 'dart:io';

import 'package:compagnon/constants.dart';
import 'package:compagnon/db/export_json.dart';
import 'package:compagnon/models/scenario.dart';
import 'package:compagnon/pages/chat/chat_body.dart';
import 'package:compagnon/pages/config/config_screen.dart';
import 'package:compagnon/pages/journal/journal_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyHomeScreen();
  }
}

class MyHomeScreen extends State<HomeScreen> {
  int selectedIndex = 0;

  Widget _chatBody = RestartWidget();
  Widget _chatBody2 = RestartWidget();
  Widget _journalBody = JournalScreen();
  Widget _configBody = ConfigScreen();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: bodySelected(),
      bottomNavigationBar: navigationbar(),
    );
  }

  BottomNavigationBar navigationbar() {
    return BottomNavigationBar(
      backgroundColor: Colors.teal,
      unselectedItemColor: Colors.white.withOpacity(0.8),
      selectedItemColor: Colors.white.withOpacity(0.8),
      showSelectedLabels: true, // <-- HERE
      showUnselectedLabels: true,
      onTap: (int index) {
        this.onTapHandler(index);
      },
      items: [
        
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat,
            color: Colors.white,
            size: 30.0,
            semanticLabel: "Text",
          ),
          label: chatButton[lang],
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.book,
            color: Colors.white,
            size: 30.0,
            semanticLabel: "Text",
          ),
          label: journalButton[lang],
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: Colors.white,
            size: 30.0,
            semanticLabel: "Text",
          ),
          label: optionsButton[lang],
          backgroundColor: Colors.teal,
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.teal,
      automaticallyImplyLeading: true,
      title: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
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
    );
  }

  Widget bodySelected() {
    if (selectedIndex == 1) {
      return _journalBody;
    } else if (selectedIndex == 0) {
      //exportData();
      //final provider = Provider.of<ScenarioProvider>(context);
      //provider.initScenario(1);

      //loadingMessage = true;

      // currentScenario.initScenario(1);
      // selectedIndex = -1;

      /*
      while (loadingMessage) {
        print("Waiting ...");
      }*/

      //Ici wait 200ms
      /*
      print("Waiting 5s ...");
      sleep(const Duration(seconds: 5));
      print("Waiting end");*/

      print("return chatBody");
      if (chatBodyOptions) {
        chatBodyOptions = false;
        return _chatBody;
      } else {
        chatBodyOptions = true;
        return _chatBody2;
      }
    } else if (selectedIndex == 2) {

      return _configBody;
    }
  }

  void onTapHandler(int index) {
    this.setState(() {
      selectedIndex = index;
      print("(onTap) selectedIndex = ");
      print(selectedIndex);

      if (keyValue == index) {
        keyValue = 0;
      } else {
        keyValue = index;
      }
    });
  }
}
