import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Task {
  int id = -1;
  String title;
  bool completed;

  Task({this.id = -1, required this.title, this.completed = false});

  void toggleCompleted() {
    completed = !completed;
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
  dynamic toJson() => { 'title': title, 'completed': completed };
}