import 'package:flutter/material.dart';
import 'todo_database.dart'; 

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Color(0xFFEFEFEF), 
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<dynamic> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async {
    tasks = await TodoDatabase.fetchTasks();
    setState(() {});
  }

  void addTask(String title, String description) async {
    await TodoDatabase.addTask(title, description);
    fetchTasks();
    _titleController.clear();
    _descriptionController.clear();
  }

  void updateTask(int id, bool isCompleted) async {
    await TodoDatabase.updateTask(id, isCompleted);
    fetchTasks();
  }

  void deleteTask(int id) async {
    await TodoDatabase.deleteTask(id);
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your To-Do List', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF87A96B), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputFields(),
            SizedBox(height: 20),
            _buildTaskTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Judul tugas',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _descriptionController,
          decoration: InputDecoration(
            hintText: 'Deskripsi tugas',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => addTask(_titleController.text, _descriptionController.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF87A96B), 
          ),
          child: Text('Tambahkan Tugas', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildTaskTable() {
    return Expanded(
      child: tasks.isEmpty
          ? Center(child: Text('Belum ada tugas'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  color: task['is_completed'] == 1 ? Color(0xFFD3E4CD) : Colors.white,
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: task['is_completed'] == 1
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task['is_completed'] == 1
                            ? Color(0xFF87A96B) 
                            : Colors.black,
                      ),
                    ),
                    subtitle: Text(task['description']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: task['is_completed'] == 1,
                          onChanged: (bool? value) {
                            setState(() {
                              task['is_completed'] = value! ? 1 : 0; 
                            });
                            updateTask(task['id'], value!);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTask(task['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
