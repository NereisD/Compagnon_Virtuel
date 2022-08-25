import 'package:compagnon/models/scenario.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Colors.teal;
const kSecondaryColor = Color(0xFF00695C);
const kBackgroundColor = Color(0xFFf6f5ee);
const kLighterBackgroundColor = Color(0xFF80CBC4);

const kDefaultPadding = 10.0;

//valeur de la bottom nav bar
int keyValue = -1;
int selectedIndex = -1;
//permet relaod l'UI du journal au démarrage
bool journalReloadUI = true;

Scenario currentScenario = Scenario();

//bool loadingMessage = false;
bool chatBodyOptions = false;

bool reloadInit = true;

double screenWidth = 0;
