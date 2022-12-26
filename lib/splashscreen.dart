import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      "assets/kemenkes.png",
      height: 300,
      width: 300,
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Center(child: logo),
        ));
  }
}
