import 'dart:convert';
import 'dart:io';
import 'package:compagnon/db/message_database.dart';
import 'package:compagnon/db/notes_database.dart';
import 'package:compagnon/models/Message.dart';
import 'package:compagnon/models/todo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';

//Renvoie le path du ficher dans lequel écrire
Future<String> getLocalPath() async {
  final directory = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  return directory;
}

/* Creer un pop up qui demande a l'utilisateur si l'application
* peut accéder à ses dossiers en écriture
*/
void requestPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();
}

//Export des messages du chat
void exportChat() async {
  //Request la permission
  requestPermission();

  //On récupère l'ensemble des messages de la BD
  List<Message> listOfMessages =
      await MessageDatabase.instance.readAllMessagesNotSecret();

  /*
  //On trie uniquement les messages non secrets
  List<Message> listOfNotSecretMessages =
      listOfMessages.where((message) => message.isSecret == false).toList();
  */

  //Trie les messages (pas utile)
  //messagesExport.sort((a, b) => a.id.compareTo(b.id));

  //Créer une liste vide
  List jsonList = [];

  //Concatène les messages en fichier Json
  listOfMessages.forEach((item) => jsonList.add(json.encode(item.toJson())));
  print("listOfMessages = " + jsonList.toString());

  //Récupère le path du fichier en String
  getLocalPath().then((String affichePath) {
    print("directory path: " + affichePath);

    try {
      //Créer un nouveau fichier
      new File(affichePath + "/exportFileChat.json").create(recursive: true);

      //Ecrit sur le fichier nouvellement créer
      File(affichePath + "/exportFileChat.json")
          .writeAsStringSync(jsonList.toString());
      print('Chat data saved successfully !');

      //Sinon on affiche l'erreur
    } catch (e) {
      print('Error: $e');
    }
  });
}

//Export des messages du journal
void exportJournal() async {
  //Request la permission
  requestPermission();

  //On récupère l'ensemble des messages de la BD
  List<Todo> listOfJournal =
      await NotesDatabase.instance.readAllNotesNotSecret();

  //Trie les messages (pas utile)
  //messagesExport.sort((a, b) => a.id.compareTo(b.id));

  //Créer une liste vide
  List jsonList = [];

  //Concatène les messages en fichier Json
  listOfJournal.forEach((item) => jsonList.add(json.encode(item.toJson())));
  print("listOfJournal = " + jsonList.toString());

  //Récupère le path du fichier en String
  getLocalPath().then((String affichePath) {
    //print("directory path: " + affichePath);

    try {
      //Créer un nouveau fichier
      new File(affichePath + "/exportFileJournal.json").create(recursive: true);

      //Ecrit sur le fichier nouvellement créer
      File(affichePath + "/exportFileJournal.json")
          .writeAsStringSync(jsonList.toString());
      print('Journal data saved successfully !');

      //Sinon on affiche l'erreur
    } catch (e) {
      print('Error: $e');
    }
  });
}








  //   List<Game> getAllGamesfromfile(){
  //   try{
  //     var stringContent = File(gamesImportFile).readAsStringSync();
  //     List jsonList = json.decode(stringContent);
  //     return new List<Game>.from(
  //       jsonList.map((json) => new Game.fromJson(json)).toList()
  //     );
  //   } catch (e) {
  //     print('Error: $e');
  //   }
    
  // }

  // void exportGames(List<Game> data) {
  //   try{
  //     data.sort((a,b) => a.id.compareTo(b.id));
  //     List jsonList = [];
  //     data.forEach((item) => jsonList.add(json.encode(item.toJson())));
  //     File(gamesExportFile).writeAsStringSync(jsonList.toString());
  //     print('Saved data successfully!');
  //   } catch (e) {
  //     print('Error: $e');
  //   }
    
  // }
