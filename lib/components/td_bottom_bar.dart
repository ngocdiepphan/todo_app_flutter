import 'package:flutter/material.dart';

import 'package:todo_app_flutter/resources/app_color.dart';

import '../pages/complete_work.dart';
import '../pages/home_page.dart';


class TdBottomBar extends StatelessWidget {
  const TdBottomBar({
    super.key,
  });
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Color.fromARGB(255, 16, 72, 241),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Business',
          backgroundColor: Color.fromARGB(255, 16, 72, 241),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'School',
          backgroundColor: Color.fromARGB(255, 16, 72, 241),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
          backgroundColor: Color.fromARGB(255, 16, 72, 241),
        ),
      ],
      currentIndex: _selectedIndex,
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
        }
      },
      // selectedItemColor: Colors.red,
    );
  }

  void showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Example Dialog'),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }
}

