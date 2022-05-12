import 'package:compagnon/constants.dart';
import 'package:compagnon/models/todo.dart';
import 'package:compagnon/providers/todos.dart';
import 'package:compagnon/pages/journal/components/todo_widget.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    provider.refreshNotes();
    final todos = provider.todos;
    debugPrint('Init TodoListWidget');

    return todos.isEmpty
        ? Center(
            child: Text(
              noDataField[lang],
              style: TextStyle(fontSize: 20),
            ),
          )
        : GroupedListView<Todo, DateTime>(
            padding: const EdgeInsets.all(16),
            physics: BouncingScrollPhysics(),
            reverse: false,
            order: GroupedListOrder.DESC,
            useStickyGroupSeparators: true,
            floatingHeader: true,
            elements: todos, // La liste des todos va ici
            groupBy: (todo) => DateTime(
              //On regroupe les messages d'un même jour ensemble
              todo.createdTime.year,
              todo.createdTime.month,
              todo.createdTime.day,
            ),
            groupHeaderBuilder: (Todo todo) => SizedBox(
              height: 40,
              child: Center(
                child: Card(
                  color: Theme.of(context).secondaryHeaderColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      //Nécessite la librairie intl
                      DateFormat.yMMMd().format(todo.createdTime),
                      //Style du widget date (le fond bleu)
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            itemBuilder: (context, todo) {
              //final todo = todos[index];
              return TodoWidget(todo: todo);
            },
          );
  }
}
