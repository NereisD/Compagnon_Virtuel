import 'package:flutter/material.dart';


/* Un Message correspond a une bulle de dialogue
* Les messages seront inscrits dans l'historique (sauf les secrets)
*/
class Message {
  final int id;
  final String text;
  final DateTime date;
  final bool isSentByMe;
  bool isLiked;
  bool isSecret;


  //Constructeur du message
  Message({
    @required this.id,
    @required this.text,
    @required this.date,
    @required this.isSentByMe,
  }) {
    isLiked = false;
    isSecret = false;
  }

  void setIsLiked(bool b) {
    isLiked = b;
  }

  void setIsSecret(bool b) {
    isSecret = b;
  }
}