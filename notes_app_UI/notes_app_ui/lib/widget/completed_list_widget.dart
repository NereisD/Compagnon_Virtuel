import 'package:flutter/material.dart';
import 'package:notes_app_ui/widget/todo_widget.dart';
import 'package:provider/provider.dart';
import 'package:notes_app_ui/provider/todos.dart';

class CompletedListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    final todos = provider.todosSecret;

    return todos.isEmpty
        ? Center(
            child: Text(
              'No secret journal',
              style: TextStyle(fontSize: 20),
            ),
          )
        : ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16),
            separatorBuilder: (context, index) => Container(height: 10),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return TodoWidget(todo: todo);
            },
          );
  }
}
