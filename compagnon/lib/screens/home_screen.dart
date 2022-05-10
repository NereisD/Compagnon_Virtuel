
import 'package:compagnon/screens/chat/chat_body.dart';

import 'package:compagnon/screens/journal/journal_screen.dart';
import 'package:flutter/material.dart';



class HomeScreen extends StatefulWidget {

    HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyHomeScreen();
  }
}

class MyHomeScreen extends State<HomeScreen> {
  int selectedIndex = 0;

  Widget _chatBody = ChatBody();
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
    unselectedItemColor: Colors.white.withOpacity(0.7),
    selectedItemColor: Colors.white,
    showSelectedLabels: true,   // <-- HERE
    showUnselectedLabels: true,
    onTap: (int index) {
          this.onTapHandler(index);
        },
    items : const [
      BottomNavigationBarItem(
          icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: 30.0,
                semanticLabel: "Text",
                
             ),
          label: "Reglage",
          backgroundColor: Colors.teal,
      ),
      BottomNavigationBarItem(
        icon: Icon(
                Icons.delete,
                color: Colors.white,
                size: 30.0,
                semanticLabel: "Text",
            ),
        label: 'Supprimer',
        backgroundColor: Colors.teal,

      ),
      BottomNavigationBarItem(
        icon: Icon(
                Icons.book,
                color: Colors.white,
                size: 30.0,
                semanticLabel: "Text",
            ),
        label: "Journal",
        backgroundColor: Colors.teal,
      ),
      BottomNavigationBarItem(
        icon: Icon(
                Icons.question_mark,
                color: Colors.white,
                size: 30.0,
                semanticLabel: "Text",
            ),
        label: "Secret",
        backgroundColor: Colors.teal,
      ),
      BottomNavigationBarItem(
        icon: Icon(
                Icons.favorite,
                color: Colors.white,
                size: 30.0,
                semanticLabel: "Text",
            ),
        label: "Like",
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
    if(selectedIndex == 0) {
          return this._chatBody;
        } else if(this.selectedIndex==2) {
          return this._journalBody;
        }

  }

    void onTapHandler(int index)  {
    this.setState(() {
      this.selectedIndex = index;
    });
  }


  
}


