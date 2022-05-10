import 'package:flutter/material.dart';




class barnavigation extends StatelessWidget {

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.teal,
      unselectedItemColor: Colors.white.withOpacity(0.7),
      selectedItemColor: Colors.white,
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
                  Icons.linked_camera,
                  color: Colors.white,
                  size: 30.0,
                  semanticLabel: "Text",
              ),
          label: 'dffg',
          backgroundColor: Colors.teal,

        ),
        BottomNavigationBarItem(
          icon: Icon(
                  Icons.link,
                  color: Colors.white,
                  size: 30.0,
                  semanticLabel: "Text",
              ),
          label: "test",
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 30.0,
                  semanticLabel: "Text",
              ),
          label: "test",
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
                  Icons.settings,
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

