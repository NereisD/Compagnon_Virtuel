import 'package:compagnon/screens/barNavigation.dart';
import 'package:compagnon/screens/chat/components/InputMessage.dart';
import 'package:compagnon/screens/chat/components/chatBox.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Expanded(
          flex: 5,
          child: chatBox(),
        ),
        
        InputMessage(iInput: 1),
      ],
    );
  }

 
}

