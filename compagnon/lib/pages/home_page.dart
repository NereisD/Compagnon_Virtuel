import 'package:compagnon/constants.dart';
import 'package:compagnon/db/export_json.dart';
import 'package:compagnon/pages/chat/chat_body.dart';
import 'package:compagnon/pages/journal/journal_screen.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyHomeScreen();
  }
}

class MyHomeScreen extends State<HomeScreen> {
  //int selectedIndex = 0;

  Widget _chatBody = RestartWidget();
  Widget _journalBody = JournalScreen();

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
            Icons.settings,
            color: Colors.white,
            size: 30.0,
            semanticLabel: "Text",
          ),
          label: optionsButton[lang],
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.delete,
            color: keyValue == 1 ? Colors.black : Colors.white,
            size: 30.0,
            semanticLabel: "Text",
          ),
          label: deleteButton[lang],
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
            Icons.favorite,
            color: keyValue == 3 ? Colors.red : Colors.white,
            size: 30.0,
            semanticLabel: "Text",
          ),
          label: likeButton[lang],
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.vpn_key,
            color: keyValue == 4 ? Colors.orange : Colors.white,
            size: 30.0,
            semanticLabel: "Text",
          ),
          label: secretsButton[lang],
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
    if (selectedIndex == 2) {
      return this._journalBody;
    } else if (selectedIndex == 0) {
      exportChat();
      exportJournal();
      return this._chatBody;
    } else {
      return this._chatBody;
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
