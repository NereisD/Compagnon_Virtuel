import 'package:compagnon/models/scenario.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Colors.teal;
const kSecondaryColor = Color(0xFF00695C);
const kBackgroundColor = Color(0xFFf6f5ee);
const kLighterBackgroundColor = Color(0xFF80CBC4);

const kDefaultPadding = 10.0;

//valeur de la bottom nav bar
int keyValue = 0;
int selectedIndex = -1;
//permet relaod l'UI du journal au démarrage
bool journalReloadUI = true;

int lang = 1;
/* Variables des strings en différentes langues
* indice 0 : Anglais
* indice 1 : Français
* indice 2 : Japonais
*/
const appTitle = ["Compagnon", "Compagnon", "仲間"];

/* Buttons */
const chatButton = ["Chat", "Discussion", ""];
const optionsButton = ["Options", "Reglages", "設定"];
const deleteButton = ["Delete", "Supprimer", "消去"];
const deleteAllButton = ["Delete all", "Supprimer tout", "消去"];
const journalButton = ["Journal", "Journal", "ジャーナル"];
const secretsButton = ["Secrets", "Secrets", "秘密"];
const likeButton = ["Like", "Aimer", "お気に入り"];

/* Fields */
const noDataField = ["No data", "Aucune donnée", "データなし"];
const editJournalField = ["Edit journal", "Editer le journal", "ジャーナルを編集する"];
const editField = ["Edit", "Editer", "変化する"];
const deleteField = ["Delete", "Supprimer", "消去"];
const titleField = ["Title", "Titre", "タイトル"];
const descriptionField = ["Description", "Description", "説明"];
const saveField = ["Save", "Sauvegarder", "保存する"];
const addNoteField = ["Add note", "Ajouter une page", "ページを追加"];
const writeTextField = [
  "Write a text here",
  "Ecrivez un message ici",
  "ここにテキストを書く"
];

/* Snack bar */
const noteSecretSnack = [
  "Note is now secret",
  "La page est maintenant secrète",
  "ページは秘密になりました"
];
const noteNotSecretSnack = [
  "Note is no longer secret",
  "La page n'est plus secrète",
  "ページはもはや秘密ではありません"
];
const noteDeletedSnack = ["Note is deleted", "Page supprimée", "削除されたページ"];
const exportSnack = [
  "Exporting data ...",
  "Export des données ...",
  "データのエクスポート"
];

/* Warnings */
const emptyTitleWarning = [
  "The title cannot be empty",
  "Le titre doit être rempli",
  "タイトルを記入する必要があります"
];

Scenario currentScenario = Scenario();

//bool loadingMessage = false;
bool chatBodyOptions = false;
