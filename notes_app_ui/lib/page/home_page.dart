import 'package:flutter/material.dart';
import 'package:notes_app_ui/db/notes_database.dart';
import 'package:notes_app_ui/main.dart';
import 'package:notes_app_ui/provider/todos.dart';
import 'package:notes_app_ui/widget/add_todo_dialog_widget.dart';
import 'package:notes_app_ui/widget/completed_list_widget.dart';
import 'package:notes_app_ui/widget/todo_list_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TodoListWidget(),
      CompletedListWidget(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.vpn_key, size: 28),
            label: 'Secrets',
          ),
        ],
      ),
      body: tabs[selectedIndex],
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.black,
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AddTodoDialogWidget(),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
