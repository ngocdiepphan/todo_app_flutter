import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/td_app_bar.dart';
import '../components/search_box.dart';
import '../components/todo_item.dart';
import '../models/todo_model.dart';
import '../resources/app_color.dart';
import '../services/local/sharedPrefs_complete.dart';
import '../services/local/shared_prefs.dart';
import 'delete_work.dart';
import 'doing_work.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'globals.dart' as globals;

class CompleteWork extends StatefulWidget {
  final String title;

  const CompleteWork({super.key, required this.title});

  @override
  State<CompleteWork> createState() => _CompleteWorkState();
}

class _CompleteWorkState extends State<CompleteWork> {
  final _searchController = TextEditingController();
  final _addController = TextEditingController();
  final _addFocus = FocusNode();
  bool _showAddBox = false;

  final SharedPrefs _prefs = SharedPrefs();
  // ignore: non_constant_identifier_names
  final SharedPrefs_Complete _prefs_complete = SharedPrefs_Complete();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  List<TodoModel> _todosComplete = [];
  List<TodoModel> _todos = [];
  List<TodoModel> _searches = [];
  final List<TodoModel> _complete = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getTodosComplete();
    _onItemTapped(1);
    _getTodos();
  }

  _getTodosComplete() {
    _prefs_complete.getTodos().then((value) {
    _todosComplete = value ?? _complete;
    _searches = [..._todosComplete];
    setState(() {});
    });
  }

  _getTodos() {
    _prefs.getTodos().then((value) {
    _todos = value ?? todosInit;
    setState(() {});
    });
  }

  _searchTodos(String searchText) {
    searchText = searchText.toLowerCase();
    _searches = _todosComplete
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
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DeletedWork(
        title: 'Deleted-work',
        deletedItems: [_searches[index]], // Truyền danh sách mục công việc đã xóa
      ),
    ),
  );
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
                                _todosComplete.remove(todo);
                                _searches.remove(todo);
                                globals.deletedTodos.add(todo);
                                _prefs_complete.addTodos(_todosComplete);
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
                    if (_todosComplete.isNotEmpty) {
                      id = (_todosComplete.last.id ?? 0) + 1;
                    }
                    TodoModel todo = TodoModel()
                      ..id = id
                      ..text = text;
                    _todos.add(todo);
                    _todosComplete.add(todo);
                    _prefs.addTodos(_todos);
                    _prefs_complete.addTodos(_todosComplete);
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
                    builder: (context) =>
                        const DoingWork(title: 'Doing-work'),
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
