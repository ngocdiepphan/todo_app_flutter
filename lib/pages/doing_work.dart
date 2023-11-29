import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_flutter/services/local/sharedPrefs_doing.dart';
import '../components/td_app_bar.dart';
import '../components/search_box.dart';
import '../components/todo_item.dart';
import '../models/todo_model.dart';
import '../resources/app_color.dart';
import '../services/local/sharedPrefs_complete.dart';
import '../services/local/shared_prefs.dart';
import 'complete_work.dart';
import 'delete_work.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'globals.dart' as globals;

class DoingWork extends StatefulWidget {
  final String title;

  const DoingWork({super.key, required this.title});

  @override
  State<DoingWork> createState() => _DoingWorkState();
}

class _DoingWorkState extends State<DoingWork> {
  final _searchController = TextEditingController();
  final _addController = TextEditingController();
  final _addFocus = FocusNode();
  bool _showAddBox = false;

  final SharedPrefs _prefs = SharedPrefs();
  // ignore: non_constant_identifier_names
  final SharedPrefs_Complete _prefs_complete = SharedPrefs_Complete();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  // ignore: non_constant_identifier_names
  final SharedPrefs_Doing _prefs_doing = SharedPrefs_Doing();
  List<TodoModel> _todos = [];
  List<TodoModel> _todoscomplete = [];
  List<TodoModel> _searches = [];
  final List<TodoModel> _doing = [];
  final List<TodoModel> _complete = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getTodos();
    _onItemTapped(2);
    _getTodosComplete();
  }

  _getTodos() {
    _prefs.getTodos().then((value) {
      _todos = value ?? todosInit;
      for(int i = 0; i< _todos.length; i++){
        if(_todos[i].isDone != true){
          _doing.add(_todos[i]);
        }
      }
      _searches = [..._doing];
      setState(() {});
    });
  }

  _getTodosComplete() {
    _prefs_complete.getTodos().then((value) {
      _todoscomplete = value ?? _complete;
      // _searches = [..._todos];
      setState(() {});
    });
  }

  _searchTodos(String searchText) {
    searchText = searchText.toLowerCase();
    _searches = _todos
        .where((element) =>
            (element.text ?? '').toLowerCase().contains(searchText))
        .toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: TdAppBar(
          rightPressed: () async {
            bool? status = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('😍'),
                content: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Do you want to logout?',
                        style: TextStyle(fontSize: 22.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            if (status ?? false) {
              SharedPreferences pfs = await prefs;
              pfs.setString('active', '0');
              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(title: 'title'),
                  ));
            }
          },
          title: widget.title),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0)
                    .copyWith(top: 12.0, bottom: 92.0),
                child: Column(
                  children: [
                    SearchBox(
                        onChanged: (value) =>
                            setState(() => _searchTodos(value)),
                        controller: _searchController),
                    const Divider(
                        height: 32.6, thickness: 1.36, color: AppColor.grey),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _searches.length,
                      itemBuilder: (context, index) {
                        TodoModel todo = _searches.reversed.toList()[index];
                        return TodoItem(
                          onTap: () {
                            setState(() {
                              todo.isDone = !(todo.isDone ?? false);
                              _prefs.addTodos(_todos);
                              _prefs_doing.addTodos(_todos);
                              _searches.remove(todo);
                              if (todo.isDone == true) {
                                _todoscomplete.add(todo);
                              }
                              _prefs_complete.addTodos(_todoscomplete);
                            });
                          },
                          onDeleted: () async {
                            bool? status = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('😍'),
                                content: Row(
                                  children: const [
                                    Expanded(
                                      child: Text(
                                        'Do you want to remove the todo?',
                                        style: TextStyle(fontSize: 22.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            if (status ?? false) {
                              setState(() {
                                 todo.isDelete = true;
                                _todos.remove(todo);
                                _searches.remove(todo);
                                globals.deletedTodos.add(todo);
                                _prefs_complete.addTodos(_todos);
                              });
                            }
                          },
                          text: todo.text ?? '-:-',
                          isDone: todo.isDone ?? false, 
                          isDelete: todo.isDelete ?? false,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16.8),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20.0,
            right: 20.0,
            bottom: 14.6,
            child: Row(
              children: [
                Expanded(
                  child: Visibility(
                    visible: _showAddBox,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 5.6),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border.all(color: AppColor.blue),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColor.shadow,
                            offset: Offset(0.0, 3.0),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _addController,
                        focusNode: _addFocus,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add a new todo item',
                          hintStyle: TextStyle(color: AppColor.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18.0),
                GestureDetector(
                  onTap: () {
                    _showAddBox = !_showAddBox;

                    if (_showAddBox) {
                      setState(() {});
                      _addFocus.requestFocus();
                      return;
                    }

                    String text = _addController.text.trim();
                    if (text.isEmpty) {
                      setState(() {});
                      FocusScope.of(context).unfocus();
                      return;
                    }

                    int id = 1;
                    if (_todos.isNotEmpty) {
                      id = (_todos.last.id ?? 0) + 1;
                    }
                    TodoModel todo = TodoModel()
                      ..id = id
                      ..text = text;
                    _todos.add(todo);
                    _prefs_complete.addTodos(_todos);
                    _addController.clear();
                    _searchController.clear();
                    _searchTodos('');
                    setState(() {});
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14.6),
                    decoration: BoxDecoration(
                      color: AppColor.blue,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColor.shadow,
                          offset: Offset(0.0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add,
                        size: 32.0, color: AppColor.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 16, 72, 241),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: 'Complete',
            backgroundColor: Color.fromARGB(255, 16, 72, 241),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Doing',
            backgroundColor: Color.fromARGB(255, 16, 72, 241),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Color.fromARGB(255, 16, 72, 241),
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(title: 'HomePage'),
                  ));
              break;
            case 1:
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const CompleteWork(title: 'Complete-work'),
                  ));
              break;
            case 2:
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoingWork(title: 'Doing-work'),
                  ));
                  break; 
                case 3:
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const DeletedWork(title: 'Delete-work', deletedItems: [],),
                  ));
          }
          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
      ),
    );
  }
}
