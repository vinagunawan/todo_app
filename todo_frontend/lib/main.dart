import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<dynamic> tasks = []; // Menambahkan tipe data List<dynamic>
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> fetchTasks() async {
    final response = await http.get(Uri.parse('http://localhost:3000/tasks'));
    if (response.statusCode == 200) {
      setState(() {
        tasks = json.decode(response.body);
      });
    }
  }

  Future<void> addTask(String title, String description) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/tasks'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'title': title, 'description': description}),
    );
    if (response.statusCode == 200) {
      fetchTasks();
      _titleController.clear();
      _descriptionController.clear();
    }
  }

  Future<void> updateTask(int id, bool isCompleted) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/tasks/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'is_completed': isCompleted ? 1 : 0}),
    );
    if (response.statusCode == 200) {
      fetchTasks();
    }
  }

  Future<void> deleteTask(int id) async {
    await http.delete(Uri.parse('http://localhost:3000/tasks/$id'));
    fetchTasks();
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Aplikasi To-Do List'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan judul tugas',
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan deskripsi tugas',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addTask(_titleController.text, _descriptionController.text);
                    },
                    child: Text('Tambahkan Tugas'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        decoration: task['is_completed'] == 1
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(task['description']), // Menampilkan deskripsi tugas
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: task['is_completed'] == 1,
                          onChanged: (bool? value) {
                            updateTask(task['id'], value!);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteTask(task['id']),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
