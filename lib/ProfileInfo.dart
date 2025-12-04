import 'package:Absen_BBWS/api.dart';
import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  // TextEditingControllers
  late TextEditingController firstNameCont;
  late TextEditingController lastNameCont;
  late TextEditingController emailCont;
  late TextEditingController passwordCont;
  late TextEditingController sekolahCont;
  late TextEditingController alamatCont;
  late TextEditingController pendidikanCont;
  late TextEditingController jurusanCont;
  late TextEditingController ttlCont;
  late TextEditingController domisiliCont;

  @override
  void initState() {
    super.initState();

    emailCont = TextEditingController(text: user['email']?.toString() ?? '');
    passwordCont = TextEditingController();
    sekolahCont =
        TextEditingController(text: user['sekolah']?.toString() ?? '');
    alamatCont = TextEditingController(text: user['alamat']?.toString() ?? '');
    pendidikanCont = TextEditingController(
        text: user['pendidikan_terakhir']?.toString() ?? '');
    jurusanCont =
        TextEditingController(text: user['jurusan']?.toString() ?? '');
    ttlCont = TextEditingController(text: user['TTL']?.toString() ?? '');
    domisiliCont =
        TextEditingController(text: user['domisili']?.toString() ?? '');
  }

  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: biru,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          child: Stack(
            children: [
              profileCard(context),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 18, left: 16, right: 16, bottom: 70),
                  child: Column(
                    children: [
                      100.height,
                      Container(
                        decoration: shadowCard(),
                        width: lebar(context) * 0.8,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Edit Profile',
                                  style: boldTextStyle(size: 24)),
                              16.height,
                              buildTextField('Email', emailCont,
                                  inputType: TextInputType.emailAddress,
                                  email: true),
                              16.height,
                              buildTextField(
                                  'Sekolah/Perguruan Tinggi', sekolahCont),
                              16.height,
                              buildTextField(
                                  'Pendidikan Terakhir', pendidikanCont),
                              16.height,
                              buildTextField('Jurusan', jurusanCont),
                              16.height,
                              datePicker(context, ttlCont),
                              16.height,
                              buildTextField('Domisili', domisiliCont),
                              16.height,
                              // dropdownField(
                              //   Listunit,
                              //   onChanged: (newValue) {
                              //     if (newValue is Map) {
                              //       setState(() {
                              //         Dataunit = newValue['id']?.toString() ?? '';
                              //       });
                              //     }
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                      30.height,
                      GestureDetector(
                        onTap: () async {
                          final Map<String, dynamic> data = {
                            'email': emailCont.text,
                            'sekolah': sekolahCont.text,
                            'alamat': alamatCont.text,
                            'pendidikan_terakhir': pendidikanCont.text,
                            'jurusan': jurusanCont.text,
                            'TTL': ttlCont.text,
                            'domisili': domisiliCont.text,
                            'id': user['id'].toString(),
                          };
                          await edit(context, data).then((value) {
                            if (value != null) {
                              setState(() {
                                user = value;
                              });
                            }
                          });
                        },
                        child: Container(
                          height: tinggi(context) * 0.05,
                          width: lebar(context) * 0.4,
                          child: loginButton("Submit", kuning, Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
