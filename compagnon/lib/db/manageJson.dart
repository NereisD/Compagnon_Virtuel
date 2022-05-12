import 'dart:convert';
import 'dart:io';
import 'package:compagnon/db/MessageDatabase.dart';
import 'package:compagnon/models/Message.dart';
import 'package:path_provider/path_provider.dart';

//Renvoie le path du ficher dans lequel écrire
Future<String> getLocalPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

void exportData() async {
  List<Message> listOfMessages =
      await MessageDatabase.instance.readAllMessages();

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
      new File(affichePath + "/exportFileMessages.json")
          .create(recursive: true);

      //Ecrit sur le fichier nouvellement créer
      File(affichePath + "/exportFileMessages.json")
          .writeAsStringSync(jsonList.toString());
      print('Data saved successfully!');

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
