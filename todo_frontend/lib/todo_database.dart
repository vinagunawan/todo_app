import 'dart:convert';
import 'package:http/http.dart' as http;

class TodoDatabase {
  static Future<List<dynamic>> fetchTasks() async {
    final response = await http.get(Uri.parse('http://localhost:3000/tasks'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  static Future<void> addTask(String title, String description) async {
    await http.post(
      Uri.parse('http://localhost:3000/tasks'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'title': title, 'description': description}),
    );
  }

  static Future<void> updateTask(int id, bool isCompleted) async {
    await http.put(
      Uri.parse('http://localhost:3000/tasks/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'is_completed': isCompleted ? 1 : 0}),
    );
  }

  static Future<void> deleteTask(int id) async {
    await http.delete(Uri.parse('http://localhost:3000/tasks/$id'));
  }
}
