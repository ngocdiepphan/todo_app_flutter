import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/custom_button.dart';
import '../components/custom_text_field.dart';
import '../models/authen.dart';
import 'login_page.dart';

class SignUp extends StatefulWidget {
  final String title;
  const SignUp({super.key, required this.title});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Authen? user;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 26.0,
                  ),
                  const Text(
                    'SignUp',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 153, 0),
                      fontSize: 32.0,
                    ),
                  ),
                  const SizedBox(
                    height: 26.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Username',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 153, 0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomTextField(
                      controller: usernameController,
                      hintText: 'Username',
                      icon: Icons.accessibility,
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(
                    height: 26.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 153, 0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      icon: Icons.ac_unit,
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(
                    height: 26.0,
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.2,
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      onPressed: () async {
                        String username = usernameController.text.trim();
                        String password = passwordController.text.trim();

                        if (username == "" && password == "") {
                          String notifycation =
                              'Phải nhập Username và Pasword ⚠';
                          final snakbar = SnackBar(
                            content: Text(notifycation),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snakbar);
                        } else {
                          final prefs = await _prefs;
                          Authen user = Authen()
                            ..name = username
                            ..pass = password;
                          final map = user.toJson();
                          prefs.setString('user', jsonEncode(map));
                          FocusScope.of(context).unfocus();

                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginPage(title: 'Login')));
                        }
                      },
                      text: 'Signup',
                    ),
                  ),
                  const SizedBox(
                    height: 26.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already a member?',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 78, 234),
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(width: 10.0,),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginPage(title: 'Login'),
                              ));
                        },
                        child: const Text('Login',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 209, 224),
                                fontSize: 16.0)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

