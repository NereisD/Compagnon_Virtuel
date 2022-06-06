import 'package:compagnon/values/constants.dart';
import 'package:compagnon/values/languages.dart';
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
      backgroundColor: kSecondaryColor,
      unselectedItemColor: Colors.white.withOpacity(0.8),
      selectedItemColor: Colors.white.withOpacity(0.8),
      showSelectedLabels: true, // <-- HERE
      showUnselectedLabels: true,
      onTap: (int index) {
        this.onTapHandler(index);
      },
      items: [
        /*
        BottomNavigationBarItem(
          icon: Icon(
            Icons.delete_forever,
            color: Colors.white,
            size: 30.0,
            semanticLabel: "Text",
          ),
          label: deleteAllButton[lang],
          backgroundColor: kSecondaryColor,
        ),*/
        BottomNavigationBarItem(
          icon: Icon(
            Icons.delete,
            color: keyValue == 0 ? Colors.black87 : Colors.white,
            size: 25.0,
            semanticLabel: "Text",
          ),
          label: deleteButton[lang],
          backgroundColor: kSecondaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite,
            color: keyValue == 1 ? Colors.red : Colors.white,
            size: 25.0,
            semanticLabel: "Text",
          ),
          label: likeButton[lang],
          backgroundColor: kSecondaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.vpn_key,
            color: keyValue == 2 ? Colors.orange : Colors.white,
            size: 25.0,
            semanticLabel: "Text",
          ),
          label: secretsButton[lang],
          backgroundColor: kSecondaryColor,
        ),
      ],
    );
  }

  void onTapHandler(int index) {
    this.setState(() {
      /*selectedIndex = index;
      print("(onTap) selectedIndex = ");
      print(selectedIndex);*/

      if (keyValue == index) {
        keyValue = -1;
      } else {
        keyValue = index;
      }
    });
  }
}
