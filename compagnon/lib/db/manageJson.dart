import 'dart:convert';
import 'dart:io';

import 'package:compagnon/db/MessageDatabase.dart';
import 'package:compagnon/models/Message.dart';
import 'package:path_provider/path_provider.dart';


Future<String> get  localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print("directory path: "+directory.path);
    return directory.path;
  }

  
  String pathComputer = '/Users/jesushedo/Flutter/jsonfiles/assets/data/';
  String messageExportFile = localPath as String;



  void exportData() async {
    List<Message> messagesExport =  await MessageDatabase.instance.readAllMessages();
    try{
      messagesExport.sort((a,b) => a.id.compareTo(b.id));
      List jsonList = [];
      new File("/data/user/0/com.example.compagnon/app_flutter/ExportMessage.json").create(recursive: true);
      messagesExport.forEach((item) => jsonList.add(json.encode(item.toJson())));
      print("test" + jsonList.toString());
      File("/data/user/0/com.example.compagnon/app_flutter/ExportMessage.json").writeAsStringSync(jsonList.toString());
      print('Saved data successfully!');
    } catch (e) {
      print('Error: $e');
    }
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
