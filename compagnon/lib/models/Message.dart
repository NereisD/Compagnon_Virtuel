import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final String tableMessages = 'messages';

class MessageField {
  static final List<String> values = [
    id,
    text,
    date,
    isSentByMe,
    isLiked,
    isSecret,
  ];

  static const String id = '_id';
  static const String text = 'text';
  static const String date = 'date';
  static const String isSentByMe = 'isSentByMe';
  static const String isLiked = 'isLiked';
  static const String isSecret = 'isSecret';
}

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
    this.id,
    @required this.date,
    @required this.text,
    @required this.isSentByMe,
    this.isLiked = false,
    this.isSecret = false,
  });

  Message copy({
    int id,
    DateTime date,
    String text,
    bool isSentByMe,
    bool isLiked,
    bool isSecret,
  }) =>
      Message(
        id: id ?? this.id,
        date: date ?? this.date,
        text: text ?? this.text,
        isSentByMe: isSentByMe ?? this.isSentByMe,
        isLiked: isLiked ?? this.isLiked,
        isSecret: isSecret ?? this.isSecret,
      );

  //Transforme Json Message en map
  static Message fromJson(Map<String, Object> json) => Message(
        id: json[MessageField.id] as int,
        date: DateTime.parse(
          json[MessageField.date] as String,
        ),
        text: json[MessageField.text] as String,
        isSentByMe: json[MessageField.isSentByMe] == 1,
        isLiked: json[MessageField.isLiked] == 1,
        isSecret: json[MessageField.isSecret] == 1,
      );

  //Transforme une map en Json Message
  Map<String, Object> toJson() => {
        MessageField.id: id,
        MessageField.date: date.toIso8601String(),
        MessageField.text: text,
        MessageField.isSentByMe: isSentByMe ? 1 : 0,
        MessageField.isLiked: isLiked ? 1 : 0,
        MessageField.isSecret: isSecret ? 1 : 0,
      };

  /*
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'date': date,
      'isSentByMe': isSentByMe,
      'isLiked': isLiked,
      'isSecret': isSecret
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) => Message(
        map['id'],
        map['text'],
        map['date'],
        map['isSentByMe'] == 1,
        map['isLiked'] == 1,
        map['isSecret'] == 1,
      );*/

  void setIsLiked(bool b) {
    isLiked = b;
  }

  void setIsSecret(bool b) {
    isSecret = b;
  }
}
