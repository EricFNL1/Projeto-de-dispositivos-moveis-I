import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.system,
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String? _selectedCategory;
  String searchQuery = '';
  List<String> _categories = ['Trabalho', 'Casa', 'Pessoal'];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _addTask() {
    if (_controller.text.isNotEmpty && _selectedCategory != null) {
      setState(() {
        _tasks.add({
          'title': _controller.text,
          'category': _selectedCategory,
          'isCompleted': false,
        });
        _controller.clear();
        _selectedCategory = null;
      });
      _saveTasks();
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  void _editTask(int index) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController editController =
        TextEditingController(text: _tasks[index]['title']);
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: TextField(
            controller: editController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks[index]['title'] = editController.text;
                });
                _saveTasks();
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', jsonEncode(_tasks));
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksData = prefs.getString('tasks');
    if (tasksData != null) {
      setState(() {
        _tasks = List<Map<String, dynamic>>.from(jsonDecode(tasksData));
      });
    }
  }

  void _exportTasks() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/tasks.txt');
    String taskList = _tasks
        .map((task) => "${task['title']} - ${task['category']}")
        .join('\n');
    await file.writeAsString(taskList);
    Share.shareFiles([file.path], text: 'Minhas Tarefas');
  }

  List<Map<String, dynamic>> _getFilteredTasks() {
    if (searchQuery.isEmpty) {
      return _tasks;
    }
    return _tasks
        .where((task) => task['title']
        .toLowerCase()
        .contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minhas Tarefas',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Adicionar nova tarefa',
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addTask,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    hint: Text('Selecione uma categoria'),
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar tarefas...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _getFilteredTasks().length,
                itemBuilder: (context, index) {
                  final task = _getFilteredTasks()[index];
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      _removeTask(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tarefa excluída!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text(task['title']),
                        subtitle: Text('Categoria: ${task['category']}'),
                        leading: Checkbox(
                          value: task['isCompleted'],
                          onChanged: (bool? value) {
                            setState(() {
                              task['isCompleted'] = value!;
                            });
                            _saveTasks();
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editTask(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _exportTasks,
        child: Icon(Icons.share),
        backgroundColor: Colors.white,
      ),
    );
  }
}
