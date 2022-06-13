import 'package:compagnon/values/constants.dart';
import 'package:compagnon/db/export_json.dart';
import 'package:compagnon/db/import_json.dart';
import 'package:compagnon/flutter_flow/flutter_flow_util.dart';
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
  String _surname = currentScenario.getVariableByName("surname");
  String _name = currentScenario.getVariableByName("name");
  String _birthday = currentScenario.getVariableByName("birthday");
  String _notificationTime =
      currentScenario.getVariableByName("notificationTime");
  String _gender = currentScenario.getVariableByName("gender");
  int _lang = getLanguage();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding * 3),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          //Pour rendre la fenètre scrollable
          child: Column(
            children: [
              Text(
                settingsField[lang],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                initialValue: _surname,
                decoration: InputDecoration(
                  labelText: surnameField[lang],
                ),
                onChanged: (value) {
                  setState(() => _surname = value);
                },
              ),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: nameField[lang],
                ),
                onChanged: (value) {
                  setState(() => _name = value);
                },
              ),
              TextFormField(
                controller: dateinput,
                decoration: InputDecoration(
                  labelText: birthField[lang],
                ),
                onChanged: (value) {
                  setState(() => _birthday = value);
                },
                readOnly:
                    true, //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
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
                decoration: InputDecoration(
                  labelText: notificationTimeField[lang],
                ),
                onChanged: (value) {
                  setState(() => _notificationTime = value);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding / 2),
              ),
              Text(
                langField[lang],
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
                        _lang = 0;
                      });
                    }, // Image tapped
                    child: Card(
                      elevation: 8,
                      child: Image.asset(
                        'assets/images/royaume-uni.png',
                        fit: BoxFit.cover, // Fixes border issues
                        width: 48.0,
                        height: 32,
                        color: _lang == 0
                            ? Colors.white.withOpacity(1)
                            : Colors.white.withOpacity(0.4),
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
                        _lang = 1;
                      });
                    }, // Image tapped
                    child: Card(
                      elevation: 8,
                      child: Image.asset(
                        'assets/images/france.png',
                        fit: BoxFit.cover, // Fixes border issues
                        width: 48.0,
                        height: 32,
                        color: _lang == 1
                            ? Colors.white.withOpacity(1)
                            : Colors.white.withOpacity(0.4),
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
                        _lang = 2;
                      });
                    }, // Image tapped
                    child: Card(
                      elevation: 8,
                      child: Image.asset(
                        'assets/images/japon.png',
                        fit: BoxFit.cover, // Fixes border issues
                        width: 48.0,
                        height: 32,
                        color: _lang == 2
                            ? Colors.white.withOpacity(1)
                            : Colors.white.withOpacity(0.4),
                        colorBlendMode: BlendMode.modulate,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: RaisedButton(
                  color: kSecondaryColor,
                  onPressed: () {
                    //modifie la langue
                    if (_lang == 0) {
                      currentScenario.setVariable("lang", "en");
                    } else if (_lang == 1) {
                      currentScenario.setVariable("lang", "fr");
                    } else if (_lang == 2) {
                      currentScenario.setVariable("lang", "jp");
                    }
                    //modifie le nom
                    currentScenario.setVariable("surname", _surname);
                    //modifie le prénom
                    currentScenario.setVariable("name", _name);
                    //modifie la date de naissance
                    currentScenario.setVariable("birthday", _birthday);
                    //modifie l'heure des notifications
                    currentScenario.setVariable(
                        "notificationTime", _notificationTime);
                    //modifie le genre
                    currentScenario.setVariable("gender", _gender);
                    showSnackbar(context, saveDataSnack[lang]);
                  },
                  child: Text(
                    validateButton[lang],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
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
                      importScenarios(
                          false); //mettre a false pour lire dans le répertoire DOWNLOAD
                    },
                    child: Text(importButton[lang]),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      exportData();
                    },
                    child: Text(exportButton[lang]),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
