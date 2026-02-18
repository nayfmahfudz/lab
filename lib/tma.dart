import 'dart:convert';
import 'dart:io';

import 'package:Absen_BBWS/api.dart';
import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:flutter/material.dart';

class TmaScreen extends StatefulWidget {
  final Map? data;
  const TmaScreen({super.key, this.data});

  @override
  State<TmaScreen> createState() => _TmaScreenState();
}

class _TmaScreenState extends State<TmaScreen> {
  final TextEditingController nomenklaturController = TextEditingController();
  String selectedWaktu = "Pagi";
  final TmaDebitEntry tmaEntry = TmaDebitEntry();

  @override
  void initState() {
    super.initState();

    // Jika ada data awal (edit mode), isi form
    if (widget.data != null) {
      nomenklaturController.text = widget.data?["nomenklatur"].toString() ?? "";
      selectedWaktu = widget.data?["waktu"]?.toString() ?? "Pagi";
      tmaEntry.tmaController.text = widget.data?["TMA"].toString() ?? "";
      tmaEntry.debitController.text = widget.data?["debit"].toString() ?? "";
    }
  }

  void _submitTMA() {
    try {
      final Map<String, dynamic> data = {};

      void addIfNotEmpty(String key, String? value) {
        if (value != null && value.trim().isNotEmpty) {
          data[key] = value.trim();
        }
      }

      addIfNotEmpty("longitude", longitude.text);
      addIfNotEmpty("latitude", latitude.text);
      addIfNotEmpty("nomenklatur", nomenklaturController.text);
      addIfNotEmpty("waktu", selectedWaktu);

      if (nomenklaturController.text.trim().isEmpty) {
        showFailPopup(context, "Nomenklatur wajib diisi!");
        return;
      }

      if (tmaEntry.tmaController.text.isEmpty) {
        showFailPopup(context, "Nilai TMA harus diisi!");
        return;
      }

      addIfNotEmpty("TMA", tmaEntry.tmaController.text);
      addIfNotEmpty("debit", tmaEntry.debitController.text);
      data["user"] = user["id"].toString();
      if (tmaEntry.imageTMA != null) {
        data["foto_TMA"] = tmaEntry.imageTMA;
      } else {
        showFailPopup(context, "Foto TMA wajib diupload!");
        return;
      }

      // Panggil API
      laporTMA(context, data).then((onValue) {
        if (onValue != null && onValue["status"] == "Success") {
          showSuccessPopup(context, onValue["message"]);
          // Reset atau kembali
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        } else {
          showFailPopup(context, onValue?["message"] ?? "Gagal mengirim data");
        }
      });
    } catch (e) {
      print(e);
      showFailPopup(context, "Terjadi kesalahan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          color: biru,
          constraints: BoxConstraints(minHeight: tinggi(context)),
          child: Column(
            children: [
              SizedBox(height: tinggi(context) * 0.12),
              const Text(
                'Input Data TMA',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Form Lokasi (Menggunakan widget dari progress.dart/component)
              formCard(context),

              const SizedBox(height: 40),

              // Tombol Submit
              GestureDetector(
                onTap: _submitTMA,
                child: SizedBox(
                  height: 50,
                  width: lebar(context) * 0.8,
                  child: loginButton("Kirim Laporan TMA", kuning, hitam),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget formCard(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
            decoration: const BoxDecoration(
              color: putih,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                    color: hitam,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 5))
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: lebar(context) * 0.06),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: dropdownFieldphs(
                    ["Pagi", "Sore"],
                    onChanged: (val) {
                      setState(() {
                        selectedWaktu = val!;
                      });
                    },
                  ),
                ),
                SizedBox(height: lebar(context) * 0.05),
                progressForm(
                    nomenklaturController, "Nama Bangunan", "", context),
                SizedBox(height: lebar(context) * 0.05),
                progressForm(latitude, "Latitude", "", context),
                SizedBox(height: lebar(context) * 0.05),
                progressForm(longitude, "Longitude", "", context),
                SizedBox(height: lebar(context) * 0.05),
                progressForm(
                    tmaEntry.tmaController, "Tinggi Muka Air", "cm", context),
                const SizedBox(height: 10),
                tombolUploadTMA(tmaEntry),
                const SizedBox(height: 10),
                SizedBox(height: lebar(context) * 0.05),
                progressForm(
                    tmaEntry.debitController, "Debit", "L/detik", context),
                SizedBox(height: lebar(context) * 0.06),
              ],
            )));
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
              entry.imageTMA != null
                  ? 'Foto Terupload'
                  : 'Upload Foto Peilschaal',
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
}

class TmaDebitEntry {
  final TextEditingController tmaController = TextEditingController();
  final TextEditingController debitController = TextEditingController();
  File? imageTMA;
}
