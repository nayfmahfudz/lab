import 'package:Absen_BBWS/setting.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      "assets/logo.png",
      height: 300,
      width: 300,
    );

    return Scaffold(
        backgroundColor: biru,
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logo,
                const Text(
                  "BBWS BRANTAS",
                  style: TextStyle(color: Colors.black, fontSize: 40),
                )
              ],
            ),
          ),
        ));
  }
}
