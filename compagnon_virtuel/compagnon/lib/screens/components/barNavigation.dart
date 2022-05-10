import 'package:flutter/material.dart';




class barnavigation extends StatelessWidget {

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.teal,
      unselectedItemColor: Colors.white.withOpacity(0.7),
      selectedItemColor: Colors.white,
      showSelectedLabels: false,   // <-- HERE
      showUnselectedLabels: false,
      items : const [
        BottomNavigationBarItem(
            icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 30.0,
                  semanticLabel: "Text",
                  
               ),
            label: "ezee",
            backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
                  Icons.question_mark,
                  color: Colors.white,
                  size: 30.0,
                  semanticLabel: "Text",
              ),
          label: 'dffg',
          backgroundColor: Colors.teal,

        ),
        BottomNavigationBarItem(
          icon: Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 30.0,
                  semanticLabel: "Text",
              ),
          label: "test",
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
                  Icons.gamepad,
                  color: Colors.white,
                  size: 30.0,
                  semanticLabel: "Text",
              ),
          label: "test",
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 30.0,
                  semanticLabel: "Text",
              ),
          label: "test",
          backgroundColor: Colors.teal,
        ),
      ],
    );
    
  }
}

