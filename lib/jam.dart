import 'dart:io';

import 'package:Absen_BBLKS/setting.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mac_address/mac_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

import 'fom.dart';

class Jam extends StatefulWidget {
  const Jam();

  @override
  State<Jam> createState() => _JamState();
}

class _JamState extends State<Jam> {
  @override
  Future uploadImage(
      File file, String lat, String long, String mac, String absen) async {
    try {
      if (file == null) {
        return "Foto Tidak ada";
      }
      if (lat == null || lat == "" && long == null || long == "") {
        return "Foto Tidak ada";
      }
      String fileName = file.path.split('/').last;

      FormData formData = FormData.fromMap({
        "foto": await MultipartFile.fromFile(file.path, filename: fileName),
        "lat": lat,
        "long": long,
        "mac_address": mac
      });
      var response = await Dio()
          .post("http://192.168.6.3:8000/api/absenlogs", data: formData);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

// DateFormat('EEEE, d MMM, yyyy.', "id_ID")
//                                             .format(DateTime.now())) ??
//                                         ""
  XFile photo = null;
  bool serviceEnabled;
  String masuk = "";
  String keluar = "";
  String mac;
  String outputnip = "";
  TextEditingController nipText = TextEditingController();
  LocationPermission permission;
  final ImagePicker _picker = ImagePicker();
  callBackNip() async {
    final prefs = await SharedPreferences.getInstance();
    nip(
      context,
      nipText,
      (String value) {
        setState(() {
          outputnip = value;
          prefs.setString('nip', value);
        });
      },
    );
  }

  absen(String absen) async {
    final prefs = await SharedPreferences.getInstance();
    await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (nipText.text == "") {
      callBackNip();
    } else if (!serviceEnabled) {
      berhasil(context, "Izin Location Ditolak");
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      await _picker
          .pickImage(source: ImageSource.camera)
          .then((value) => {value != null ? photo = value : null});
      photo != null
          ? uploadImage(File(photo.path), position.latitude.toString(),
                  position.longitude.toString(), outputnip, absen)
              .then((value) => {
                    if (value["success"] == true)
                      {berhasil(context, value["message"])}
                    else
                      {berhasil(context, value)}
                  })
          : null;
      photo = null;
    }
  }

  ambilData() async {
    final prefs = await SharedPreferences.getInstance();
    outputnip = prefs.getString('nip') ?? "";
    keluar = prefs.getString('keluar') ?? "";
    masuk = prefs.getString('masuk') ?? "";
    setState(() {
      nipText.text = outputnip;
    });
  }

  @override
  void initState() {
    ambilData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: biru,
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => callBackNip(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.145,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.roboto(
                              fontSize: 32,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            )),
                        Expanded(
                            child: Text(outputnip,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                )))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: DigitalClock(
                    digitAnimationStyle: Curves.easeIn,
                    showSecondsDigit: false,
                    areaDecoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    hourMinuteDigitTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 100,
                    ),
                    amPmDigitTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Masuk",
                                  style: GoogleFonts.roboto(
                                    fontSize: 26,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    textStyle:
                                        Theme.of(context).textTheme.subtitle1,
                                  )),
                              Text(masuk,
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    color: birumuda,
                                    fontWeight: FontWeight.w500,
                                    textStyle:
                                        Theme.of(context).textTheme.subtitle1,
                                  )),
                              SizedBox(
                                height: 40,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    masuk = DateFormat('h:mm,d MMM', "id_ID")
                                        .format(DateTime.now());

                                    absen("masuk");
                                  });
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('masuk', masuk);
                                },
                                child: loginButton(
                                    "Absen Masuk", birumuda, Colors.black),
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Keluar",
                                  style: GoogleFonts.roboto(
                                    fontSize: 26,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    textStyle:
                                        Theme.of(context).textTheme.subtitle1,
                                  )),
                              Text(keluar,
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    color: birumuda,
                                    fontWeight: FontWeight.w500,
                                    textStyle:
                                        Theme.of(context).textTheme.subtitle1,
                                  )),
                              SizedBox(
                                height: 40,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    keluar = DateFormat('h:mm,d MMM', "id_ID")
                                        .format(DateTime.now());
                                    absen("keluar");
                                  });
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('keluar', keluar);
                                },
                                child: loginButton(
                                    "Absen Keluar", birumuda, Colors.black),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
