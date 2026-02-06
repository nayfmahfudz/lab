import 'package:Absen_BBWS/api.dart';
import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/jam.dart';
import 'package:Absen_BBWS/option.dart';
import 'package:Absen_BBWS/profile.dart';
import 'package:Absen_BBWS/progress.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late PageController _pageController;
  List<Widget> screen() {
    if (user["petugas_lapangan"].toString() == "0") {
      return <Widget>[
        Jam(),
        ProfileScreen(),
      ];
    } else {
      return <Widget>[
        Jam(),
        Option(),
        ProfileScreen(),
      ];
    }
  }

  double lebarBottom(BuildContext context) {
    if (user["petugas_lapangan"].toString() == "0") {
      return lebar(context) * 0.5;
    } else {
      return lebar(context) * 0.6;
    }
  }

  List<BottomNavyBarItem> bottomBarItem() {
    if (user["petugas_lapangan"].toString() == "0") {
      return [
        BottomNavyBarItem(
            title: const Text('Home'), icon: const Icon(Icons.home)),
        BottomNavyBarItem(
            title: const Text('Settings'),
            icon: const Icon(Icons.account_circle))
      ];
    } else
      return [
        BottomNavyBarItem(
            title: const Text('Home'), icon: const Icon(Icons.home)),
        BottomNavyBarItem(
            title: const Text('Progress'), icon: const Icon(Icons.bar_chart)),
        BottomNavyBarItem(
            title: const Text('Settings'),
            icon: const Icon(Icons.account_circle)),
      ];
  }

  @override
  void initState() {
    super.initState();
    cekData(user["id"]).then((value) {
      setState(() {
        masuk;
        keluar;
      });
    });
    loadJson();
    loadJsonDI();
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
        color: biru,
        child: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: screen(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: lebarBottom(context),
        padding: EdgeInsets.only(
          bottom: 16.0,
        ),
        child: BottomNavyBar(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            cekLokasi(context).then((value) {
              if (value is Position) {
                latitude.text = value.latitude.toString();
                longitude.text = value.longitude.toString();
              }
            });
            cekData(user["id"]).then((value) {
              setState(() {
                _currentIndex = index;
                masuk;
                keluar;
              });
            });
            _pageController.jumpToPage(index);
          },
          items: bottomBarItem(),
        ),
      ),
    );
  }
}
