import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_flutter/pages/forgotpass_page.dart';
import 'package:todo_app_flutter/pages/sign_up.dart';

import '../components/custom_button.dart';
import '../components/custom_text_field.dart';
import '../models/authen.dart';
import 'forgotpass_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({super.key, required this.title});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                    'Login',
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
                        style: TextStyle(color: Color.fromARGB(255, 255, 153, 0),),
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
                        style: TextStyle(color: Color.fromARGB(255, 255, 153, 0),),
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

                        SharedPreferences pref = await _prefs;
                        String? data = pref.getString('user');
                        if (data == null) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SignUp(title: 'title'),
                              ));
                        } else {
                          final mapa = jsonDecode(data);
                          user = Authen.fromJson(mapa);
                        }

                        //ignore: unrelated_type_equality_checks
                        if (username == user!.name && password == user!.pass) {
                          final prefs = await _prefs;
                          Authen user = Authen()
                            ..name = username
                            ..pass = password;
                          final map = user.toJson();
                          prefs.setString('user', jsonEncode(map));
                          prefs.setString('active', '1');
                          // ignore: use_build_context_synchronously
                          FocusScope.of(context).unfocus();

                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const HomePage(title: 'HomePage'),
                              ));
                        } else {
                          if (username == "" && password == "") {
                            String notifycation =
                                'Phải nhập Username và Pasword ⚠';
                            final snakbar = SnackBar(
                              content: Text(notifycation),
                            );
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(snakbar);
                          } else {
                            String notifycation = 'Đăng nhập thất bại ❌';
                            final snakbar = SnackBar(
                              content: Text(notifycation),
                            );
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(snakbar);
                          }
                        }
                      },
                      text: 'Login',
                    ),  
                  ),
                  
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 12.6,
            child: IntrinsicHeight(
              child: Row(
                // color: Colors.amber[300],
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(title: 'SignUp'),
                          ));
                    },
                    child: const Text('SignUp',
                        style: TextStyle(color: Color.fromARGB(255, 0, 209, 224), fontSize: 16.0)),
                  ),
                  const VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassPage(title: 'Forgot Password'),
                          ));
                    },
                    child: const Text('Forgot password',
                        style: TextStyle(color: Color.fromARGB(255, 255, 140, 0), fontSize: 16.0)),
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

