import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/todo_model.dart';

class SharedPrefs_Delete {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<TodoModel>?> getDeletedTodos() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString('deleted');
    if (data == null) return null;
    List<Map<String, dynamic>> maps = jsonDecode(data)
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;
    List<TodoModel> deletedTodos =
        maps.map((e) => TodoModel.fromJson(e)).toList();
    return deletedTodos;
  }

  Future<void> addDeletedTodos(List<TodoModel> deletedTodos) async {
    List<Map<String, dynamic>> maps =
        deletedTodos.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setString('deleted', jsonEncode(maps));
  }
}
