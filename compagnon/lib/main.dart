import 'package:compagnon/values/constants.dart';
import 'package:compagnon/providers/todos.dart';
import 'package:compagnon/pages/home_page.dart';
import 'package:compagnon/values/languages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = appTitle[lang];
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
          home: SplashScreenPage(),
        ),
      );
}

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: HomeScreen(),
      backgroundColor: Colors.teal,
      title: new Text('Compagnon',textScaleFactor: 2,),
      image: Image.asset(
            'assets/images/robot.png',
            fit: BoxFit.cover,
          ),
      loadingText: Text("Loading"),
      photoSize: 110.0,
      loaderColor: Colors.white,
    );
  }
}

