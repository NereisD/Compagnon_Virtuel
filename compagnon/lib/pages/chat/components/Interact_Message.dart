import 'package:compagnon/constants.dart';
import 'package:flutter/material.dart';

class interactMessage extends StatefulWidget {
  interactMessage({Key key}) : super(key: key);

  @override
  State<interactMessage> createState() => _interactMessageState();
}





class _interactMessageState extends State<interactMessage> {
  @override
  Widget build(BuildContext context) {
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
            Icons.delete_forever,
            color: Colors.white,
            size: 30.0,
            semanticLabel: "Text",
          ),
          label: deleteAllButton[lang],
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
            Icons.favorite,
            color: keyValue == 2 ? Colors.red : Colors.white,
            size: 30.0,
            semanticLabel: "Text",
          ),
          label: likeButton[lang],
          backgroundColor: Colors.teal,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.vpn_key,
            color: keyValue == 3 ? Colors.yellow : Colors.white,
            size: 30.0,
            semanticLabel: "Text",
          ),
          label: secretsButton[lang],
          backgroundColor: Colors.teal,
        ),
      ],
    );
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