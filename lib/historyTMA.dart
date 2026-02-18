import 'dart:convert';
import 'dart:io';

import 'package:Absen_BBWS/api.dart';
import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HistortTMAScreen extends StatefulWidget {
  final Map? data;
  const HistortTMAScreen({super.key, this.data});

  @override
  State<HistortTMAScreen> createState() => _HistortTMAScreenState();
}

class _HistortTMAScreenState extends State<HistortTMAScreen> {
  bool isLoading = true;
  List historyData = [];

  @override
  void initState() {
    super.initState();
    getHistory().then((onValue) {
      if (onValue != null && onValue["status"] == "Success") {
        setState(() {
          historyData = onValue["data"] ?? [];
          isLoading = false;
        });
      } else {
        showFailPopup(context, onValue?["message"] ?? "Gagal memuat data");
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((error) {
      showFailPopup(context, "Terjadi kesalahan: $error");
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat TMA',
            style: TextStyle(color: hitam, fontWeight: FontWeight.bold)),
        backgroundColor: biru,
        iconTheme: const IconThemeData(color: hitam),
      ),
      body: Container(
        color: biru,
        height: tinggi(context),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: kuning))
            : historyData.isEmpty
                ? const Center(
                    child: Text("Belum ada data riwayat",
                        style: TextStyle(color: putih, fontSize: 16)))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 20, bottom: 50),
                    itemCount: historyData.length,
                    itemBuilder: (context, index) {
                      return historyCard(historyData[index]);
                    },
                  ),
      ),
    );
  }

  Widget historyCard(Map data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: putih,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
                color: hitam,
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data['nomenklatur'] ?? 'Tanpa Nama',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: hitam),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kuning,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data['jam'] ?? '-',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: hitam),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoItem("TMA", "${data['TMA'] ?? '-'} cm"),
                _infoItem("Debit", "${data['debit'] ?? '-'} L/detik"),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoItem(
                    "Tanggal",
                    data['createdAt'] != null
                        ? data['createdAt'].toString().split('T')[0]
                        : '-'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: hitam)),
      ],
    );
  }
}
