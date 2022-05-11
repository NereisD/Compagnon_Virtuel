import 'package:compagnon/providers/todos.dart';
import 'package:compagnon/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Compagnon';
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => TodosProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            secondaryHeaderColor: Colors.teal[800],
            scaffoldBackgroundColor: Color(0xFFf6f5ee),
          ),
          home: HomeScreen(),
        ),
      );
}
