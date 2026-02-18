import 'dart:convert';
import 'dart:io';

import 'package:Absen_BBWS/api.dart';
import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/home.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';

class ProgressLapanngan extends StatefulWidget {
  final Map? data;
  const ProgressLapanngan({super.key, this.data});

  @override
  State<ProgressLapanngan> createState() => _ProgressLapannganState();
}

class _ProgressLapannganState extends State<ProgressLapanngan> {
  int currentStep = 0;
  // Tambahkan deklarasi TextEditingController di sini
  final TextEditingController angkatSedimenController = TextEditingController();
  final TextEditingController menutupBocoranController =
      TextEditingController();
  final TextEditingController panjangSaluranController =
      TextEditingController();
  final TextEditingController luasAreaController = TextEditingController();
  final TextEditingController potongPohonController = TextEditingController();
  final TextEditingController pengecatanPintuController =
      TextEditingController();
  final TextEditingController pembersihanSampahController =
      TextEditingController();
  final TextEditingController pelumasanPintuController =
      TextEditingController();
  final TextEditingController babatRumputController = TextEditingController();
  final TextEditingController kegiatanLainController = TextEditingController();
  final TextEditingController WK = TextEditingController();
  String KerjaIndividu = "1";
  List<TmaDebitEntry> tmaEntries = [];

  @override
  void initState() {
    tmaEntries.add(TmaDebitEntry());
    if (widget.data != null) {
      currentStep = [
        widget.data?["progress_1"],
        widget.data?["progress_50"],
        widget.data?["progress_100"]
      ].where((element) => element != null).toList().length;
      tmaEntries[0].tmaController.text = widget.data?["TMA"].toString() ?? "";
      WK.text = widget.data?["wilayah_kerja"].toString() ?? "";
      tmaEntries[0].debitController.text =
          widget.data?["debit"].toString() ?? "";
      angkatSedimenController.text =
          widget.data?["angkat_sedimen"].toString() ?? "";
      menutupBocoranController.text =
          widget.data?["menutup_bocoran"].toString() ?? "";
      panjangSaluranController.text =
          widget.data?["panjang_saluran"].toString() ?? "";
      luasAreaController.text =
          widget.data?["luas_area_kegiatan"].toString() ?? "";
      potongPohonController.text =
          widget.data?["angkat_potong_pohon"].toString() ?? "";
      pengecatanPintuController.text =
          widget.data?["pengecatan_pintu_air"].toString() ?? "";
      pembersihanSampahController.text =
          widget.data?["pembersihan_sampah"].toString() ?? "";
      pelumasanPintuController.text =
          widget.data?["pelumasan_pintu_air"].toString() ?? "";
      babatRumputController.text =
          widget.data?["babat_rumput"].toString() ?? "";
      kegiatanLainController.text =
          widget.data?["kegiatan_lain"].toString() ?? "";
    }
    super.initState();
  }

  List listProgress = [0, 1, 50, 100];
  void _nextStep() {
    try {
      final Map<String, dynamic> data = {};
      var id;
      void addIfNotEmpty(String key, String? value) {
        if (value != null && value.trim().isNotEmpty) {
          data[key] = value.trim();
        }
      }

      addIfNotEmpty("longitude", longitude.text);
      addIfNotEmpty("latitude", latitude.text);
      addIfNotEmpty("angkat_sedimen", angkatSedimenController.text);
      addIfNotEmpty("menutup_bocoran", menutupBocoranController.text);
      addIfNotEmpty("panjang_saluran", panjangSaluranController.text);
      addIfNotEmpty("luas_area_kegiatan", luasAreaController.text);
      addIfNotEmpty("angkat_potong_pohon", potongPohonController.text);
      addIfNotEmpty("pengecatan_pintu_air", pengecatanPintuController.text);
      addIfNotEmpty("pembersihan_sampah", pembersihanSampahController.text);
      addIfNotEmpty("pelumasan_pintu_air", pelumasanPintuController.text);
      addIfNotEmpty("babat_rumput", babatRumputController.text);
      addIfNotEmpty("kegiatan_lain", kegiatanLainController.text);
      addIfNotEmpty("wilayah_kerja", WK.text);
      addIfNotEmpty("kerja_individu", KerjaIndividu);
      if (KerjaIndividu != "0" && KerjaIndividu != "1") {
        showFailPopup(context, "Pilih jenis kerja individu atau kelompok!");
        return;
      }
      for (int i = 0; i < tmaEntries.length; i++) {
        String suffix = "_${i + 1}";
        addIfNotEmpty("TMA$suffix", tmaEntries[i].tmaController.text);
        addIfNotEmpty("debit$suffix", tmaEntries[i].debitController.text);
        if (tmaEntries[i].imageTMA != null) {
          data["foto_TMA$suffix"] = tmaEntries[i].imageTMA;
        }
      }

      if (valueDI.toString().trim().isNotEmpty) {
        data["DI"] = valueDI;
      }

      if (valueKota.trim().isNotEmpty) {
        final found = jawaTimur
            .where((item) => item['id'].toString() == valueKota)
            .toList();
        if (found.isNotEmpty && found.first['nama'] != null) {
          data["kota"] = found.first['nama'];
        }
      }

      if (valueKecamatan.trim().isNotEmpty) {
        final found = kecamatan
            .where((item) => item['id'].toString() == valueKecamatan)
            .toList();
        if (found.isNotEmpty && found.first['nama'] != null) {
          data["kecamatan"] = found.first['nama'];
        }
      }

      if (valueKelurahan.trim().isNotEmpty) {
        final found = kelurahan
            .where((item) => item['id'].toString() == valueKelurahan)
            .toList();
        if (found.isNotEmpty && found.first['nama'] != null) {
          data["kelurahan"] = found.first['nama'];
        }
      }
      if (widget.data != null) {
        id = widget.data?["id"];
      }
      print(data);
      progress(context, currentStep, data, id: id.toString())
          .then((onValue) => {
                print(onValue),
                if (onValue["status"] == "Success")
                  {
                    setState(() {
                      if (currentStep < listProgress.length) {
                        currentStep++;
                      }
                    }),
                    showSuccessPopup(context, onValue["message"]),
                  }
                else
                  {
                    // print(onValue)
                    showFailPopup(context, onValue["message"])
                  }
              });
    } catch (e) {
      print(e);
      showFailPopup(context, "Pastikan semua data terisi!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // true = boleh back, false = ditahan
      onPopInvoked: (didPop) {
        navigateToNextScreen(context, Home());
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
            color: biru,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Text(
                  'Progress Lapangan',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 100),
                Container(
                  height: lebar(context) * 0.3,
                  width: lebar(context) * 0.3,
                  padding: const EdgeInsets.all(15.0),
                  child: PieChart(PieChartData(
                      startDegreeOffset: 70,
                      sectionsSpace: 2,
                      centerSpaceRadius:
                          60, // Inilah yang bikin dia jadi "donut"
                      sections: [
                        PieChartSectionData(
                          color: kuning,
                          value: (100 - listProgress[currentStep]).toDouble(),
                          title: '',
                          radius: 60,
                          titleStyle: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: listProgress[currentStep].toDouble(),
                          title: '${listProgress[currentStep]}%',
                          radius: 70,
                          titleStyle: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ])),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Container(
                      height: tinggi(context) * 0.2,
                      width: lebar(context),
                      padding: const EdgeInsets.all(15.0),
                      child: Timeline.tileBuilder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        builder: TimelineTileBuilder.connected(
                          connectionDirection: ConnectionDirection.before,
                          itemCount: 3,
                          contentsBuilder: (_, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: index < currentStep
                                      ? Colors.red
                                      : Colors.red.shade100,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              width: lebar(context) * 0.26,
                              height: tinggi(context) * 0.2,
                              child: Center(
                                child: Text(
                                  index < currentStep
                                      ? 'Terkirim'
                                      : 'Belum Terkirim',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          indicatorBuilder: (_, index) {
                            if (index < currentStep) {
                              return const DotIndicator(
                                color: Colors.red,
                                child: Icon(Icons.check,
                                    color: Colors.white, size: 12),
                              );
                            } else if (index == currentStep) {
                              return const DotIndicator(
                                color: Colors.redAccent,
                                child: Icon(Icons.circle,
                                    color: Colors.white, size: 12),
                              );
                            } else {
                              return OutlinedDotIndicator(
                                borderWidth: 2,
                                color: Colors.red.shade200,
                              );
                            }
                          },
                          connectorBuilder: (_, index, __) {
                            return SolidLineConnector(
                              color: index < currentStep
                                  ? Colors.red
                                  : Colors.red.shade100,
                            );
                          },
                        ),
                      )),
                ),
                const SizedBox(height: 50),
                formProgress(context),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 8, 18.0, 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentStep == 0 ? null : currentStep--;
                          });
                        },
                        child: Container(
                          height: tinggi(context) * 0.05,
                          width: lebar(context) * 0.4,
                          child: loginButton(
                              "Ulangi Progress", merah, Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentStep == listProgress.length - 1
                                ? null
                                : _nextStep();
                          });
                        },
                        child: Container(
                          height: tinggi(context) * 0.05,
                          width: lebar(context) * 0.4,
                          child: loginButton(
                              "Laporkan Progress", kuning, Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: tinggi(context) * 0.16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formProgress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: const BoxDecoration(
          color: putih,
          boxShadow: [
            BoxShadow(
                color: hitam,
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 5))
          ],
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: lebar(context) * 0.06),
            Padding(
              padding: const EdgeInsets.fromLTRB(43.0, 8, 43.0, 0),
              child: dropdownFieldphs(
                ["Kerja Individu", "Kerja Kelompok"],
                onChanged: (newValue) {
                  if (newValue == "Kerja Kelompok") {
                    setState(() {
                      KerjaIndividu = "0";
                    });
                  } else {
                    setState(() {
                      KerjaIndividu = "1";
                    });
                  }
                },
              ),
            ),
            SizedBox(height: lebar(context) * 0.06),
            rowDropdownFormDi(di, valueDI),
            rowDropdownForm(
              jawaTimur,
              valueKota,
              "kecamatan",
            ),
            rowDropdownForm(kecamatan, valueKecamatan, "kelurahan"),
            rowDropdownForm(kelurahan, valueKelurahan, ""),
            progressForm(WK, "Wilayah Kerja", "", context, enabled: false),
            SizedBox(height: lebar(context) * 0.05),
            progressForm(latitude, "latitude ", "", context),
            SizedBox(height: lebar(context) * 0.05),
            progressForm(longitude, "longitude", "", context),
            SizedBox(height: lebar(context) * 0.05),
            SizedBox(height: lebar(context) * 0.05),
            progressForm(
                angkatSedimenController, "Angkat Sedimen", "m\u00B3", context),
            SizedBox(height: lebar(context) * 0.05),
            progressForm(
                menutupBocoranController, "Menutup Bocoran", "bh", context),
            SizedBox(height: lebar(context) * 0.05),
            progressForm(
                panjangSaluranController, "Panjang Saluran", "m", context),
            SizedBox(height: lebar(context) * 0.05),
            progressForm(luasAreaController, "Luas Area", "m\u00B2", context),
            SizedBox(height: lebar(context) * 0.05),
            progressForm(potongPohonController, "potong pohon", "bh", context),
            SizedBox(height: lebar(context) * 0.05),
            progressForm(
                pengecatanPintuController, "Pengecatan Pintu", "bh", context),
            SizedBox(height: lebar(context) * 0.05),
            progressForm(pembersihanSampahController, "Pembersihan Sampah",
                "m3", context),
            SizedBox(height: lebar(context) * 0.05),
            progressForm(
                pelumasanPintuController, "Pelumasan Pintu", "bh", context),
            SizedBox(height: lebar(context) * 0.05),
            progressForm(babatRumputController, "Babat Rumput", "m3", context),
            SizedBox(height: lebar(context) * 0.05),
            progressForm(kegiatanLainController, "Kegiatan Lain", "", context,
                enabled: false),
            SizedBox(height: lebar(context) * 0.12),
          ],
        ),
      ),
    );
  }

  Widget tombolUploadTMA(TmaDebitEntry entry) => GestureDetector(
        onTap: () {
          pilihanModal(context, pilihan(
            (value) {
              setState(() {
                entry.imageTMA = value;
              });
            },
          ));
        },
        child: Container(
          decoration: BoxDecoration(
              color: entry.imageTMA != null ? biru : Colors.red.shade100,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          width: lebar(context) * 0.7,
          height: tinggi(context) * 0.05,
          child: Center(
            child: Text(
              entry.imageTMA != null ? 'Terupload' : 'Upload Peilschaal',
              style: const TextStyle(
                color: hitam,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

  Widget containerForm(
      TextEditingController controller1,
      TextEditingController controller2,
      String label1,
      String label2,
      String satuan1,
      String satuan2) {
    return Container(
      height: tinggi(context) * 0.1,
      width: lebar(context) * 0.85,
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        children: [
          progressForm(controller1, label1, satuan1, context),
          SizedBox(width: lebar(context) * 0.03),
          progressForm(controller2, label2, satuan2, context),
          SizedBox(width: lebar(context) * 0.03),
        ],
      ),
    );
  }

  Widget rowDropdownFormDi(List items1, String nilai) {
    return Container(
      height: tinggi(context) * 0.1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dropdownProgressDI(context, items1, nilai: nilai,
              onChanged: (String? value) async {
            final prefs = await SharedPreferences.getInstance();
            nilai = value!;
            prefs.setString("valueDI", jsonEncode(value));
          }),
        ],
      ),
    );
  }

  Widget rowDropdownForm(List items1, String nilai, String nilaidaerah) {
    return Container(
      height: tinggi(context) * 0.1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dropdownProgress(context, items1, nilai: nilai,
              onChanged: (String? value) async {
            print(value);
            final onValue =
                await daerah(context, nilaidaerah, int.parse(value!));
            final prefs = await SharedPreferences.getInstance();
            nilai = value;
            if (nilaidaerah == "kecamatan") {
              kecamatan = onValue;
              valueKecamatan = onValue[0]['id'].toString();
              prefs.setString("valueKota", jsonEncode(value));
              prefs.setString(nilaidaerah, jsonEncode(kecamatan));
              prefs.setString("valuekecamatan", jsonEncode(valueKecamatan));
            } else if (nilaidaerah == "kelurahan") {
              kelurahan = onValue;
              prefs.setString("valuekecamatan", jsonEncode(value));
              valueKelurahan = onValue[0]['id'].toString();
              prefs.setString(nilaidaerah, jsonEncode(kelurahan));
              prefs.setString("valuekelurahan", jsonEncode(valueKelurahan));
            } else {
              prefs.setString("valuekelurahan", jsonEncode(value));
            }
            // }
            setState(() {
              kelurahan;
              kecamatan;
              nilai;
            });
          }),
        ],
      ),
    );
  }
}

class TmaDebitEntry {
  final TextEditingController tmaController = TextEditingController();
  final TextEditingController debitController = TextEditingController();
  File? imageTMA;
}
