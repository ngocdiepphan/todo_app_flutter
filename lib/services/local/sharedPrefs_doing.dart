
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/authen.dart';
import '../../models/todo_model.dart';

// ignore: camel_case_types
class SharedPrefs_Doing {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<TodoModel>?> getTodos() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString('doing');
    if (data == null) return null;
    List<Map<String, dynamic>> maps = jsonDecode(data)
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;
    List<TodoModel> todos = maps.map((e) => TodoModel.fromJson(e)).toList();
    return todos;
  }

  Future<void> addTodos(List<TodoModel> todos) async {
    List<Map<String, dynamic>> maps = todos.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setString('doing', jsonEncode(maps));
  }
}
