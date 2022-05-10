import 'package:compagnon/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
            primarySwatch: Colors.teal,
            secondaryHeaderColor: Colors.teal[800],
            scaffoldBackgroundColor: Color(0xFFf6f5ee),
          ),
      home: ChatScreen(context),
    );
  }
}