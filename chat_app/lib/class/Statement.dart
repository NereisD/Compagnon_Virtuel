import 'package:flutter/material.dart';

/* Un Statement correspond à une ligne du script
* Peut appartenir au robot ou à l'utilisateur
*/
class Statement {
  final int id;
  final String text;
  final bool isUser;
  List<int> idAnswers = [];

  Statement({
    @required this.id,
    @required this.text,
    @required this.isUser,
    this.idAnswers,
  });
}