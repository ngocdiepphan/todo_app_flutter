import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_flutter/pages/home_page.dart';

import '../models/authen.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // Authen? user;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      _getInformation();
    });
  }

  Future<void> _getInformation() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString('user');
    String? active = prefs.getString('active');
    if (data == null || active == '0') {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(title: 'title'),
          ));
    }else{
      //ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(title: 'HomePage'),
          ));
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/Background_1.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          Center(
            child: Image.asset(
              'assets/images/Logo_1.png',
              width: 160.0,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
    );
  }
}

