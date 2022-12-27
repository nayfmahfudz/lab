import 'dart:io';

import 'package:balai_lab/setting.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mac_address/mac_address.dart';

import 'fom.dart';

class Jam extends StatefulWidget {
  const Jam();

  @override
  State<Jam> createState() => _JamState();
}

class _JamState extends State<Jam> {
  @override
  Future uploadImage(File file, String lat, String long, String mac) async {
    try {
      print(mac);
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "foto": await MultipartFile.fromFile(file.path, filename: fileName),
        "lat": lat,
        "long": long,
        "mac_address": mac
      });
      var response = await Dio()
          .post("http://192.168.77.235/api/absenlogs", data: formData);
      print(response.statusCode);
      print(response.data);
      return response.data;
    } catch (e) {
      return {"success": false};
    }
  }

  XFile photo = null;
  bool serviceEnabled;
  String mac;
  LocationPermission permission;
  final ImagePicker _picker = ImagePicker();
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: biru,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnalogClock(
                  dateTime: DateTime.now(),
                  isKeepTime: true,
                  child: const Align(
                    alignment: FractionalOffset(0.5, 0.75),
                    child: Text('GMT+8'),
                  ),
                ),
                Expanded(
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
                              Text("",
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    textStyle:
                                        Theme.of(context).textTheme.subtitle1,
                                  )),
                              SizedBox(
                                height: 40,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  mac = await GetMac.macAddress;
                                  serviceEnabled = await Geolocator
                                      .isLocationServiceEnabled();
                                  if (!serviceEnabled) {
                                    return Future.error(
                                        'Location services are disabled');
                                  }

                                  permission =
                                      await Geolocator.checkPermission();
                                  if (permission == LocationPermission.denied) {
                                    permission =
                                        await Geolocator.requestPermission();
                                    if (permission ==
                                        LocationPermission.denied) {
                                      return Future.error(
                                          'Location permissions are denied');
                                    } else {
                                      Position position =
                                          await Geolocator.getCurrentPosition(
                                              desiredAccuracy:
                                                  LocationAccuracy.high);

                                      await _picker
                                          .pickImage(source: ImageSource.camera)
                                          .then((value) => {
                                                value != null
                                                    ? photo = value
                                                    : null
                                              });
                                      photo != null
                                          ? uploadImage(
                                                  File(photo.path),
                                                  position.latitude.toString(),
                                                  position.longitude.toString(),
                                                  mac)
                                              .then((value) => {
                                                    if (value["success"] ==
                                                        true)
                                                      {
                                                        berhasil(context,
                                                            value["message"])
                                                      }
                                                    else
                                                      {
                                                        berhasil(context,
                                                            "Absen Gagal")
                                                      }
                                                  })
                                          : null;
                                      photo = null;
                                    }
                                  } else {
                                    Position position =
                                        await Geolocator.getCurrentPosition(
                                            desiredAccuracy:
                                                LocationAccuracy.high);

                                    await _picker
                                        .pickImage(source: ImageSource.camera)
                                        .then((value) => {
                                              value != null
                                                  ? photo = value
                                                  : null
                                            });
                                    photo != null
                                        ? uploadImage(
                                                File(photo.path),
                                                position.latitude.toString(),
                                                position.longitude.toString(),
                                                mac)
                                            .then((value) => {
                                                  if (value["success"] == true)
                                                    {
                                                      berhasil(context,
                                                          value["message"])
                                                    }
                                                  else
                                                    {
                                                      berhasil(context,
                                                          "Absen Gagal")
                                                    }
                                                })
                                        : null;
                                    photo = null;
                                  }
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
                              Text("",
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    textStyle:
                                        Theme.of(context).textTheme.subtitle1,
                                  )),
                              SizedBox(
                                height: 40,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  mac = await GetMac.macAddress;
                                  serviceEnabled = await Geolocator
                                      .isLocationServiceEnabled();
                                  if (!serviceEnabled) {
                                    return Future.error(
                                        'Location services are disabled');
                                  }

                                  permission =
                                      await Geolocator.checkPermission();
                                  if (permission == LocationPermission.denied) {
                                    permission =
                                        await Geolocator.requestPermission();
                                    if (permission ==
                                        LocationPermission.denied) {
                                      return Future.error(
                                          'Location permissions are denied');
                                    } else {
                                      Position position =
                                          await Geolocator.getCurrentPosition(
                                              desiredAccuracy:
                                                  LocationAccuracy.high);

                                      await _picker
                                          .pickImage(source: ImageSource.camera)
                                          .then((value) => {
                                                value != null
                                                    ? photo = value
                                                    : null
                                              });
                                      photo != null
                                          ? uploadImage(
                                                  File(photo.path),
                                                  position.latitude.toString(),
                                                  position.longitude.toString(),
                                                  mac)
                                              .then((value) => {
                                                    if (value["success"] ==
                                                        true)
                                                      {
                                                        berhasil(context,
                                                            value["message"])
                                                      }
                                                    else
                                                      {
                                                        berhasil(context,
                                                            "Absen Gagal")
                                                      }
                                                  })
                                          : null;
                                      photo = null;
                                    }
                                  } else {
                                    Position position =
                                        await Geolocator.getCurrentPosition(
                                            desiredAccuracy:
                                                LocationAccuracy.high);

                                    await _picker
                                        .pickImage(source: ImageSource.camera)
                                        .then((value) => {
                                              value != null
                                                  ? photo = value
                                                  : null
                                            });
                                    photo != null
                                        ? uploadImage(
                                                File(photo.path),
                                                position.latitude.toString(),
                                                position.longitude.toString(),
                                                mac)
                                            .then((value) => {
                                                  if (value["success"] == true)
                                                    {
                                                      berhasil(context,
                                                          value["message"])
                                                    }
                                                  else
                                                    {
                                                      berhasil(context,
                                                          "Absen Gagal")
                                                    }
                                                })
                                        : null;
                                    photo = null;
                                  }
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
