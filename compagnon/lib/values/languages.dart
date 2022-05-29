import 'package:compagnon/db/scenarios_database.dart';
import 'package:compagnon/values/constants.dart';

int lang = getLanguage();

/* Variables des strings en différentes langues
* indice 0 : Anglais
* indice 1 : Français
* indice 2 : Japonais
*/

int getLanguage() {
  String l = currentScenario.getVariableByName("lang");
  if (l == "Français 🇫🇷" || l == "fr") {
    return 1;
  } else if (l == "日本 🇯🇵" || l == "jp") {
    return 2;
  } else {
    return 0;
  }
}

const appTitle = ["Compagnon", "Compagnon", "仲間"];

/* Buttons */
const chatButton = ["Chat", "Discussion", "討論"];
const optionsButton = ["Options", "Reglages", "設定"];
const deleteButton = ["Delete", "Supprimer", "消去"];
const deleteAllButton = ["Delete all", "Supprimer tout", "消去"];
const journalButton = ["Journal", "Journal", "ジャーナル"];
const secretsButton = ["Secrets", "Secrets", "秘密"];
const likeButton = ["Like", "Aimer", "お気に入り"];
const waveButton = ["Wave to Bob 👋", "Saluer Bob 👋", "こんにちはボブ 👋"];
const validateButton = ["Validate", "Valider", "確認"];
const importButton = ["Import", "Importer", "輸入"];
const exportButton = ["Export", "Exporter", "書き出す"];

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
const helloField = ["Hello Bob !", "Bonjour Bob !", "こんにちはボブ！"];
const settingsField = ["Settings", "Paramètres", "設定"];
const surnameField = ["Surname", "Nom", "名前"];
const nameField = ["Name", "Prénom", "ファーストネーム"];
const birthField = [
  "Date of birth (DD-MM-YYYY) ",
  "Date de naissance (JJ-MM-AAAA)",
  "生年月日"
];
const notificationTimeField = [
  "Notification time",
  "Heure des notifications",
  "通知時間"
];
const langField = ["Langugage", "Langue", "言語"];

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
const saveDataSnack = ["Changes made", "Enregistrements effectués", "加えられた変更"];

/* Warnings */
const emptyTitleWarning = [
  "The title cannot be empty",
  "Le titre doit être rempli",
  "タイトルを記入する必要があります"
];
