import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Todo {
  String title;
  bool isCompleted;

  Todo(this.title, this.isCompleted);

  // Method to convert Todo to JSON
  String toJson() {
    return '{"title": "$title", "isCompleted": $isCompleted}';
  }

  // Factory method to create Todo from JSON
  factory Todo.fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    return Todo(data['title'], data['isCompleted']);
  }
}

class Todos {
  final List<Todo> _todos;
  final String _prefsKey = "todos";

  Todos() : _todos = [];

  // Method to load todos from SharedPreferences
  Future<void> loadTodosFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todosJson = prefs.getStringList(_prefsKey);

    if (todosJson != null) {
      _todos.clear();
      _todos.addAll(todosJson.map((todoJson) => Todo.fromJson(todoJson)));
    }
  }

  // Method to save todos to SharedPreferences
  Future<void> _saveTodosToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todosJson = _todos.map((todo) => todo.toJson()).toList();
    prefs.setStringList(_prefsKey, todosJson);
  }

  // Method to add a new task
  void addTask(String title) {
    _todos.add(Todo(title, false));
    _saveTodosToPrefs();
  }

  // Method to mark a task as completed
  void completeTask(int index) {
    if (index >= 0 && index < _todos.length) {
      _todos[index].isCompleted = true;
      _saveTodosToPrefs();
    }
  }

  // Method to mark a task as incomplete
  void incompleteTask(int index) {
    if (index >= 0 && index < _todos.length) {
      _todos[index].isCompleted = false;
      _saveTodosToPrefs();
    }
  }

  // Method to remove a task
  void removeTask(int index) {
    if (index >= 0 && index < _todos.length) {
      _todos.removeAt(index);
      _saveTodosToPrefs();
    }
  }

  // Method to get the list of all tasks
  List<Todo> getTasks() {
    _todos.sort((a, b) => a.isCompleted ? 1 : -1);
    return List<Todo>.of(_todos);
  }
}
