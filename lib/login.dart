import 'dart:convert';

import 'package:Absen_BBWS/api.dart';
import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/daftar.dart';
import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/home.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:animate_do/animate_do.dart';

// import 'component/api.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  var namaController = TextEditingController();
  var passwordController = TextEditingController();
  var hide = true;
  var error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [birutua, biru, birumuda])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FadeInUp(
                              duration: const Duration(milliseconds: 1000),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 40),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          FadeInUp(
                              duration: const Duration(milliseconds: 1300),
                              child: const Text(
                                "Welcome Back",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60))),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 60,
                              ),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1400),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: birumuda,
                                              blurRadius: 20,
                                              offset: Offset(0, 10))
                                        ]),
                                    child: Column(
                                      children: <Widget>[
                                        userLogin(namaController),
                                        passwordLogin(passwordController,
                                            obscureText: hide,
                                            suffixIcononChanged: () {
                                          setState(() {
                                            hide = !hide;
                                          });
                                        }),
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                height: 40,
                              ),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1500),
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1600),
                                  child: MaterialButton(
                                    onPressed: () {
                                      handleLogin(context);
                                    },
                                    height: 50,
                                    // margin: EdgeInsets.symmetric(horizontal: 50),
                                    color: birutua,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    // decoration: BoxDecoration(
                                    // ),
                                    child: const Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1800),
                                  child: MaterialButton(
                                    onPressed: () {
                                      navigateToNextScreen(
                                          context, const Daftar());
                                    },
                                    height: 50,
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Daftar",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleLogin(BuildContext context) {
    if (!formKey.currentState!.validate()) {
    } else {
      login(context, {
        "email": namaController.text,
        "password": passwordController.text
      }).then((value) async {
        if (value != null) {
          if (value["message"] == "Login successful") {
            print(value["user"]);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            user = value["user"];
            prefs.setString("user", jsonEncode(value["user"]));
            Future.delayed(const Duration(seconds: 1), () {
              replaceToNextScreen(context, const Home());
            });
            showSuccessPopup(context, value["message"]);
          } else {
            showFailPopup(context, value["message"]);
          }
        }
      });
    }
  }
}
