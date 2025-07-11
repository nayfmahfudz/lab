import 'package:Absen_BBWS/api.dart';
import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/jam.dart';
import 'package:Absen_BBWS/profile.dart';
import 'package:Absen_BBWS/progress.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    cekData(user["id"]);
    loadJson();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: const <Widget>[
              Jam(),
              ProgressLapanngan(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: lebar(context) * 0.6,
        padding: EdgeInsets.only(
          bottom: 16.0,
        ),
        child: BottomNavyBar(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                title: const Text('Home'), icon: const Icon(Icons.home)),
            BottomNavyBarItem(
                title: const Text('Progress'),
                icon: const Icon(Icons.bar_chart)),
            BottomNavyBarItem(
                title: const Text('Settings'),
                icon: const Icon(Icons.account_circle)),
          ],
        ),
      ),
    );
  }
}
