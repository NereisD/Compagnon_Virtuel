import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 10.0;

//valeur de la bottom nav bar
int keyValue = 0;
int selectedIndex = -1;
//permet relaod l'UI du journal au démarrage
bool journalReloadUI = true;

int lang = 0;
/* Variables des strings en différentes langues
* indice 0 : Anglais
* indice 1 : Français
* indice 2 : Japonais
*/
const appTitle = ["Compagnon", "Compagnon", "仲間"];

/* Buttons */
const optionsButton = ["Options", "Reglages", "設定"];
const deleteButton = ["Delete", "Supprimer", "消去"];
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

/* Warnings */
const emptyTitleWarning = [
  "The title cannot be empty",
  "Le titre doit être rempli",
  "タイトルを記入する必要があります"
];
