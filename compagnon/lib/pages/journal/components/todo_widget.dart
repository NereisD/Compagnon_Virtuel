import 'package:compagnon/values/constants.dart';
import 'package:compagnon/models/todo.dart';
import 'package:compagnon/providers/todos.dart';
import 'package:compagnon/pages/journal/edit_todo_page.dart';
import 'package:compagnon/utils.dart';
import 'package:compagnon/values/languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class TodoWidget extends StatelessWidget {
  final Todo todo;

  const TodoWidget({
    @required this.todo,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          key: Key(todo.number),
          actions: [
            IconSlideAction(
              color: Colors.green,
              caption: editField[lang],
              onTap: () => editTodo(context, todo), //bouton edit
              icon: Icons.edit,
            )
          ],
          secondaryActions: [
            IconSlideAction(
              color: Colors.red,
              caption: deleteField[lang],
              onTap: () => deleteTodo(context, todo), //bouton delete
              icon: Icons.delete,
            )
          ],
          child: buildTodo(context),
        ),
      );

  Widget buildTodo(BuildContext context) => GestureDetector(
        onTap: () => editTodo(context, todo),
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.all(6), //bof
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              Checkbox(
                activeColor: Theme.of(context).primaryColor,
                checkColor: Colors.white,
                //Icons.lock_open
                shape: CircleBorder(), //A remplacer par un padlock
                value: todo.isSecret,
                /* Lorsqu'on clique dessus, passe d'un etat secret a l'autre 
              * et deplace la note 
              */
                onChanged: (_) {
                  final provider =
                      Provider.of<TodosProvider>(context, listen: false);
                  final isSecret = provider.toggleTodoStatus(todo);
                  Utils.showSnackBar(
                    context,
                    isSecret ? noteSecretSnack[lang] : noteNotSecretSnack[lang],
                  );
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                      ),
                    ),
                    if (todo.description.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Text(todo.description,
                            style: TextStyle(fontSize: 16, height: 1.5)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  void deleteTodo(BuildContext context, Todo todo) {
    final provider = Provider.of<TodosProvider>(context, listen: false);
    provider.removeTodo(todo);

    Utils.showSnackBar(context, noteDeletedSnack[lang]);
  }

  void editTodo(BuildContext context, Todo todo) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditTodoPage(todo: todo),
        ),
      );
}
