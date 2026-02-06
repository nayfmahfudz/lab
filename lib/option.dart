import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:flutter/material.dart';
import 'progress.dart';

class Option extends StatefulWidget {
  const Option({super.key});

  @override
  State<Option> createState() => _OptionState();
}

class _OptionState extends State<Option> {
  final List<Widget> _cards = [];
  late double width;
  late double height;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    width = lebar(context) * 0.8;
    height = tinggi(context) * 0.07;
    if (_cards.isEmpty) {
      if (ruas.isNotEmpty) {
        for (var i = 0; i < ruas.length; i++) {
          _addCard(ruas[i]);
        }
      } else {
        _addCard();
      }
    }
  }

  void _addCard([Map? data]) {
    setState(() {
      if (_cards.length < (ruas.length + 1)) {
        _cards.add(_buildCard(_cards.length + 1, data));
      } else {
        showFailPopup(context, "Isi terlebih dahulu kegiatan yang ada");
      }
    });
  }

  Widget _buildCard(int cardNumber, [Map? data]) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProgressLapanngan(data: data)));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 10.0),
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
          child: Text(
            'Kegiatan Ruas $cardNumber',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: hitam),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Container(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text('Laporan Progress',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ..._cards,
            const SizedBox(height: 20),
            GestureDetector(
                onTap: _addCard,
                child: Container(
                    height: 50,
                    width: lebar(context) * 0.6,
                    child:
                        loginButton("Tambah Kegiatan", kuning, Colors.black))),
            SizedBox(height: tinggi(context) * 0.16),
          ],
        ),
      ),
    );
  }
}
