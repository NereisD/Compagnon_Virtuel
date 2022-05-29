import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  //Petite barre en bas qui indique une action effectuée
  static void showSnackBar(BuildContext context, String text) =>
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text)));
}
