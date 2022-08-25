import 'dart:io';

import 'package:compagnon/db/import_json.dart';
import 'package:compagnon/values/constants.dart';
import 'package:compagnon/db/export_json.dart';
import 'package:compagnon/models/scenario.dart';
import 'package:compagnon/pages/chat/chat_body.dart';
import 'package:compagnon/pages/settings/settings_body.dart';
import 'package:compagnon/pages/journal/journal_screen.dart';
import 'package:compagnon/values/languages.dart';

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
  Widget _configBody = SettingsBody();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: bodySelected(),
      bottomNavigationBar: navigationbar(),
    );
  }

  BottomNavigationBar navigationbar() {
    //int selectedIndex = 0;
    return BottomNavigationBar(
      backgroundColor: Colors.teal,
      unselectedItemColor: Colors.white.withOpacity(0.8),
      selectedItemColor: Colors.white.withOpacity(1),
      showSelectedLabels: true, // <-- HERE
      showUnselectedLabels: true,
      currentIndex: selectedIndex,
      onTap: (int index) {
        onTapHandler(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat,
            //color: Colors.white,
            size: 30.0,
            semanticLabel: "Text",
          ),
          label: chatButton[lang],
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.book,
            //color: Colors.white,
            size: 30.0,
            semanticLabel: "Text",
          ),
          label: journalButton[lang],
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            //color: Colors.white,
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
    currentScenario.initScenarioVariables().then((value) {
      lang = getLanguage();
    });
    if (selectedIndex == 1) {
      return _journalBody;
    } else if (selectedIndex == 0) {
      print("return chatBody");
      return _chatBody;
    } else if (selectedIndex == 2) {
      return _configBody;
    }
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
      print("(onTap) selectedIndex = ");
      print(selectedIndex);
    });
  }
}
