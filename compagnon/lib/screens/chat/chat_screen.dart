import 'package:compagnon/models/Message.dart';
import 'package:compagnon/db/MessageDatabase.dart';
import 'package:compagnon/screens/barNavigation.dart';
import 'package:compagnon/screens/chat/components/InputMessage.dart';
import 'package:compagnon/screens/chat/components/chatBox.dart';
import 'package:compagnon/screens/components/body.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
      bottomNavigationBar: barnavigation(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
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
}
