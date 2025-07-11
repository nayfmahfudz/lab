import 'package:Absen_BBWS/api.dart';
import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class ProgressLapanngan extends StatefulWidget {
  const ProgressLapanngan({super.key});

  @override
  State<ProgressLapanngan> createState() => _ProgressLapannganState();
}

class _ProgressLapannganState extends State<ProgressLapanngan> {
  @override
  // ignore: override_on_non_overriding_member
  List listProgress = [0, 1, 50, 100];
  void _nextStep() {
    progress(context, currentStep);
    setState(() {
      if (currentStep < listProgress.length) {
        currentStep++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  centerSpaceRadius: 60, // Inilah yang bikin dia jadi "donut"
                  sections: [
                    PieChartSectionData(
                      color: kuning,
                      value: (100 - listProgress[currentStep]).toDouble(),
                      title: '',
                      radius: 60,
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: listProgress[currentStep].toDouble(),
                      title: '${listProgress[currentStep]}%',
                      radius: 70,
                      titleStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ])),
            ),
            const SizedBox(height: 50),
            Container(
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        width: lebar(context) * 0.26,
                        height: tinggi(context) * 0.2,
                        child: Center(
                          child: Text(
                            index < currentStep ? 'Terkirim' : 'Belum Terkirim',
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
                          child:
                              Icon(Icons.check, color: Colors.white, size: 12),
                        );
                      } else if (index == currentStep) {
                        return const DotIndicator(
                          color: Colors.redAccent,
                          child:
                              Icon(Icons.circle, color: Colors.white, size: 12),
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
            const SizedBox(height: 50),
            formProgress(context),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed:
                    currentStep == listProgress.length - 1 ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: birumuda,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Laporkan Progress'),
              ),
            ),
            SizedBox(
              height: tinggi(context) * 0.16,
            ),
          ],
        ),
      ),
    );
  }

  Widget formProgress(BuildContext context) {
    return Column(
      children: [
        rowDropdownForm(
          jawaTimur,
          ['Pilih Lokasi', 'Pilih Lokasi'],
        ),
        containerForm(
          TextEditingController(),
          TextEditingController(),
          "Angkat Sedimen",
          "Menutup Bocoran",
          "m3",
          "bh",
        ),
        containerForm(
          TextEditingController(),
          TextEditingController(),
          "Panjang Saluran",
          "Luas Area",
          "m",
          "m2",
        ),
        containerForm(
          TextEditingController(),
          TextEditingController(),
          "potong pohon",
          "Pengecatan Pintu",
          "bh",
          "bh",
        ),
        containerForm(
          TextEditingController(),
          TextEditingController(),
          "Pembersihan Sampah",
          "Pelumasan Pintu",
          "kg",
          "bh",
        ),
      ],
    );
  }

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

  Widget rowDropdownForm(List items1, List items2) {
    return Container(
      height: tinggi(context) * 0.1,
      width: lebar(context) * 0.85,
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        children: [
          dropdownProgress(items1),
          SizedBox(width: lebar(context) * 0.12),
          dropdownProgress([]),
          SizedBox(width: lebar(context) * 0.12),
        ],
      ),
    );
  }
}
