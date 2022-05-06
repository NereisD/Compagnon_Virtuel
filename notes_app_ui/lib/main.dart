import 'package:flutter/material.dart';
import 'package:notes_app_ui/provider/todos.dart';
import 'package:provider/provider.dart';

import 'page/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Journal';

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
          home: HomePage(),
        ),
      );
}
