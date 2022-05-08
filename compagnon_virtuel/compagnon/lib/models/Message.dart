import 'package:flutter/material.dart';


/* Un Message correspond a une bulle de dialogue
* Les messages seront inscrits dans l'historique (sauf les secrets)
*/
class Message {
  final int id;
  final String text;
  final String date;
  final bool isSentByMe;
  bool isLiked;
  bool isSecret;


  //Constructeur du message
  Message(
    this.id,
    this.text,
    this.date,
    this.isSentByMe,
    this.isLiked,
    this.isSecret,
  ) {
    this.isLiked = false;
    this.isSecret = false;
  }

  void setIsLiked(bool b) {
    isLiked = b;
  }

  void setIsSecret(bool b) {
    isSecret = b;
  }

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'text' : text,
      'date' : date,
      'isSentByMe' : isSentByMe,
      'isLiked' : isLiked,
      'isSecret' : isSecret
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) => Message(
    map['id'],
    map['text'],
    map['date'],
    map['isSentByMe'] == 1,
    map['isLiked'] == 1,
    map['isSecret'] == 1,
  );
}


