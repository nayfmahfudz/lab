import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

const putih = Color.fromRGBO(249, 245, 235, 1);
const merah = Color.fromRGBO(234, 84, 85, 1);
const birutua = Color.fromRGBO(0, 43, 91, 1);
const abu = Color.fromRGBO(228, 220, 207, 1);
const biru = Color.fromRGBO(39, 135, 189, 1);
const birumuda = Color.fromRGBO(193, 221, 237, 1);
const peach = Color.fromRGBO(255, 233, 201, 1);
const orange = Color.fromRGBO(247, 130, 0, 1);
const hijau = Color.fromARGB(255, 129, 199, 132);
const kuning = Color(0xFFFBC02D); // Equivalent to yellow.shade700
const hitam = Colors.black;
var url = "http://199.99.99.10:8000"; // Localhost for Android emulator
const String appName = 'Absen BBLKS';
const String appVersion = '1.0.0';
const String appBuildNumber = '1';
const String appPackageName = 'com.example.absen_bbws';
const String appIcon = 'assets/images/logo.png';
const String appLogo = 'assets/images/logo.png';
XFile? photo;
bool serviceEnabled = false;
LocationPermission permission = LocationPermission.denied;
String masuk = "";
String keluar = "";
Map user = {};
List jawaTimur = [];
int currentStep = 0;
const dateFormat = 'MMM dd, yyyy';
