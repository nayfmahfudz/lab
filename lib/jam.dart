import 'package:Absen_BBWS/api.dart';
import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:intl/intl.dart';

import 'fom.dart';

class Jam extends StatefulWidget {
  const Jam({super.key});

  @override
  State<Jam> createState() => _JamState();
}

class _JamState extends State<Jam> {
  String outputnip = "";
  TextEditingController nipText = TextEditingController();
  late DateTime now;
  late String hari;
  late String tanggal;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    hari = DateFormat('EEEE', 'id_ID').format(now); // Hari (Senin, Selasa, dst)
    tanggal = DateFormat('d MMMM yyyy', 'id_ID').format(now);
    setState(() {
      masuk;
      keluar;
    });
  }

  @override
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
                  onTap: () {
                    setState(() {
                      nip(
                        context,
                        nipText,
                        (String value) {
                          setState(() {
                            outputnip = value;
                          });
                        },
                      );
                      nipText;
                    });
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.045,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hari + " , " + tanggal,
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                            ))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 9),
                  child: AnalogClock(
                    dateTime: DateTime.now(),
                    isKeepTime: true,
                    child: const Align(
                      alignment: FractionalOffset(0.5, 0.75),
                      child: Text(''),
                    ),
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
                                        Theme.of(context).textTheme.bodyMedium,
                                  )),
                              Text(masuk,
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )),
                              const SizedBox(
                                height: 40,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  loadingPopup(context);
                                  cekDanKirimLokasi(context).then((value) {
                                    if (value == true) {
                                      absen(context, "masuk").then((onValue) {
                                        setState(() {
                                          masuk = DateFormat("HH:mm")
                                              .format(DateTime.now())
                                              .toString();
                                          keluar;
                                        });
                                      });
                                    }
                                  });
                                },
                                child: loginButton(
                                    "Absen Masuk", kuning, Colors.black),
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
                                        Theme.of(context).textTheme.bodyMedium,
                                  )),
                              Text(keluar,
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )),
                              const SizedBox(
                                height: 40,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  loadingPopup(context);
                                  cekDanKirimLokasi(context).then((value) {
                                    if (value == true) {
                                      absen(context, "keluar").then((onValue) {
                                        setState(() {
                                          keluar = DateFormat("HH:mm")
                                              .format(DateTime.now())
                                              .toString();
                                          keluar;
                                        });
                                      });
                                    }
                                  });
                                },
                                child: loginButton(
                                    "Absen Keluar", kuning, Colors.black),
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
