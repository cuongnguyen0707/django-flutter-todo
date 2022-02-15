import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider() {
    this.fetchTaks();
  }

  List<Task> _tasks = [];

  UnmodifiableListView<Task> get allTasks => UnmodifiableListView(_tasks);
  UnmodifiableListView<Task> get incompleteTasks =>
      UnmodifiableListView(_tasks.where((todo) => !todo.completed));
  UnmodifiableListView<Task> get completedTasks =>
      UnmodifiableListView(_tasks.where((todo) => todo.completed));

  void addTodo(Task task) async {
    var url = Uri.parse("http://localhost:8000/todo");
    final response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(task),
    );
    if (response.statusCode == 201) {
      task.id = json.decode(response.body)['id'];
      _tasks.add(task);
      notifyListeners();
    }
  }

  void toggleTodo(Task task) async {
    final taskIndex = _tasks.indexOf(task);
    _tasks[taskIndex].toggleCompleted();
    var url = Uri.parse("http://localhost:8000/todo/${task.id}");
    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(task),
    );
    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      _tasks[taskIndex].toggleCompleted(); //revert back
    }
  }

  void deleteTodo(Task task) async{
    var url = Uri.parse("http://localhost:8000/todo/${task.id}");
    final response = await http.delete(url
    );
    if (response.statusCode == 204) {
      _tasks.remove(task);
      notifyListeners();
    }
  }

  fetchTaks() async {
    var url = Uri.parse("http://localhost:8000/todo");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      _tasks = data.map<Task>((json) => Task.fromJson(json)).toList();
      notifyListeners();
    }
  }
}
