import 'dart:async';
import 'dart:convert';
import 'package:Absen_BBWS/home.dart';
import 'package:Absen_BBWS/login.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:Absen_BBWS/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
// service.startService();
  @override
  State<MyApp> createState() => _MyAppState();
}

@override
class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
  }

  Future splashscreen() async {
    try {
      return await Future.delayed(const Duration(seconds: 3), () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        user = prefs.getString("user") != null
            ? jsonDecode(prefs.getString("user").toString())
            : {};
        print(user);
        // ignore: unnecessary_null_comparison
        if (user.length != 0) {
          return true;
        } else {
          return true;
        }
      });
    } catch (e) {
      if (user.length != 0) {
        return true;
      } else {
        return true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Absen BBWS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: splashscreen(),
          builder: ((context, snapshot) {
            if (snapshot.data == true) {
              if (user.isNotEmpty) {
                return const Home();
              }
              return const Login();
            } else {
              return const SplashScreen();
            }
          }),
        ));
  }
}
