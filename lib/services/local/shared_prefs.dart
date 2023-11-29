import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/todo_model.dart';

class SharedPrefs {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<TodoModel>?> getTodos() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString('delete');
    if (data == null) return null;
    List<Map<String, dynamic>> maps =
        jsonDecode(data).cast<Map<String, dynamic>>();
    List<TodoModel> todos =
        maps.map((e) => TodoModel.fromJson(e)).toList();
    return todos;
  }

  Future<void> addTodos(List<TodoModel> todos) async {
    List<Map<String, dynamic>> maps =
        todos.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setString('delete', jsonEncode(maps));
  }

  Future<List<TodoModel>?> getDeletedItems() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString('deletedItems');
    if (data == null) return null;
    List<Map<String, dynamic>> maps =
        jsonDecode(data).cast<Map<String, dynamic>>();
    List<TodoModel> deletedItems =
        maps.map((e) => TodoModel.fromJson(e)).toList();
    return deletedItems;
  }

  Future<void> addDeletedItems(List<TodoModel> deletedItems) async {
    List<Map<String, dynamic>> maps =
        deletedItems.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setString('deletedItems', jsonEncode(maps));
  }
  Future<void> saveDeletedItems(List<TodoModel> deletedItems) async {
    List<Map<String, dynamic>> maps =
        deletedItems.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setString('deletedItems', jsonEncode(maps));
  }
   Future<void> saveTodos(List<TodoModel> todos) async {
    List<Map<String, dynamic>> maps =
        todos.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setString('todos', jsonEncode(maps));
  }
}
