import 'package:compagnon/constants.dart';
import 'package:flutter/material.dart';

class TodoFormWidget extends StatelessWidget {
  final String title;
  final String description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final VoidCallback onSavedTodo;

  const TodoFormWidget({
    Key key,
    this.title = '',
    this.description = '',
    @required this.onChangedTitle,
    @required this.onChangedDescription,
    @required this.onSavedTodo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTitle(),
            SizedBox(height: 4),
            buildDescription(),
            SizedBox(height: 10),
            buildSaveButton(),
          ],
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title, //Lorsqu'on edit un todo, ancien titre
        onChanged: onChangedTitle,
        validator: (title) {
          if (title.isEmpty) {
            return emptyTitleWarning[lang];
          }
          return null;
        },
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: titleField[lang],
        ),
      );

  Widget buildDescription() => TextFormField(
        maxLines: 4, //4 lines affichées (on peut le changer)
        initialValue: description, //Lorsqu'on edit, ancienne description
        onChanged: onChangedDescription,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: descriptionField[lang],
        ),
      );

  Widget buildSaveButton() => SizedBox(
        width: double.infinity, //Prend toute la largeur
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
          onPressed: onSavedTodo,
          child: Text(saveField[lang]),
        ),
      );
}
