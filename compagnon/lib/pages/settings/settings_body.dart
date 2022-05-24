import 'package:compagnon/values/constants.dart';
import 'package:compagnon/db/export_json.dart';
import 'package:compagnon/db/import_json.dart';
import 'package:compagnon/db/scenarios_database.dart';
import 'package:compagnon/flutter_flow/flutter_flow_util.dart';
import 'package:compagnon/models/scenario.dart';
import 'package:compagnon/pages/journal/components/add_todo_dialog_widget.dart';
import 'package:compagnon/pages/journal/components/completed_list_widget.dart';
import 'package:compagnon/pages/journal/components/todo_list_widget.dart';
import 'package:compagnon/values/languages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SettingsBody extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsBody> {
  int selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();

  TextEditingController dateinput = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  String _surname = '';
  String _name = '';
  String _birthday = '';
  String _frequence = '';


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding * 3),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              "Paramètres",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              initialValue: currentScenario.getVariableByName("surname"),
              decoration: InputDecoration(labelText: "Ton nom"),
              onChanged: (value){
                (value) => setState(() => this._surname = value);
              },
            ),
            TextFormField(
              initialValue: currentScenario.getVariableByName("name"),
              decoration: InputDecoration(labelText: "Ton prenom"),
              onChanged: (value){
                (value) => setState(() => this._name = value);
              },
            ),
            TextFormField(
              controller: dateinput,
              decoration: InputDecoration(labelText: "Date de naissance (DD-MM-YYYY)"),
              onChanged: (value){
                (value) => setState(() => this._birthday = value);
              },
              readOnly:
                  true, //set it true, so that user will not able to edit text
              onTap: () async {
                DateTime pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(
                        1900), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  print(
                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  //you can implement different kind of Date Format here according to your requirement

                  setState(() {
                    dateinput.text =
                        formattedDate; //set output date to TextField value.
                  });
                } else {
                  print("Date is not selected");
                }
              
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(labelText: "heure du scénario (HH:MM)"),
              onChanged: (value){
                (value) => setState(() => this._frequence = value);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
            ),
            Text(
              "Langue",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      lang = 1;
                    });
                  }, // Image tapped
                  child: Card(
                    elevation: 8,
                    child: Image.asset(
                      'assets/images/france.png',
                      fit: BoxFit.cover, // Fixes border issues
                      width: 48.0,
                      height: 32,
                      color: lang == 1
                          ? Colors.white.withOpacity(1)
                          : Colors.white.withOpacity(0.3),
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      lang = 0;
                    });
                  }, // Image tapped
                  child: Card(
                    elevation: 8,
                    child: Image.asset(
                      'assets/images/royaume-uni.png',
                      fit: BoxFit.cover, // Fixes border issues
                      width: 48.0,
                      height: 32,
                      color: lang == 0
                          ? Colors.white.withOpacity(1)
                          : Colors.white.withOpacity(0.3),
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      lang = 2;
                    });
                  }, // Image tapped
                  child: Card(
                    elevation: 8,
                    child: Image.asset(
                      'assets/images/japon.png',
                      fit: BoxFit.cover, // Fixes border issues
                      width: 48.0,
                      height: 32,
                      color: lang == 2
                          ? Colors.white.withOpacity(1)
                          : Colors.white.withOpacity(0.3),
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  showSnackbar(context, "Enregistrement éffectué");
                },
                child: Text('Valider'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    importScenarios();
                  },
                  child: Text('Importer'),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    exportData();
                  },
                  child: Text('Exporter'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
