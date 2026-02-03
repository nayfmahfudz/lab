import 'dart:io';

import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/login.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Absen_BBWS/api.dart';

class Daftar extends StatefulWidget {
  static String tag = '/Daftar';

  const Daftar({super.key});

  @override
  DaftarState createState() => DaftarState();
}

class DaftarState extends State<Daftar> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  final firstNameCont = TextEditingController();
  final lastNameCont = TextEditingController();
  final emailCont = TextEditingController();
  final passwordCont = TextEditingController();
  final sekolahCont = TextEditingController();
  final alamatCont = TextEditingController();
  final petugasCont = TextEditingController();
  final pendidikanCont = TextEditingController();
  final jurusanCont = TextEditingController();
  final ttlCont = TextEditingController();
  final domisiliCont = TextEditingController();
  final unitCont = TextEditingController();
  final NIK = TextEditingController();
  var Dataunit = "";
  var petugaslapangan = "";
  var jabatan = "";
  List Listunit = [];
  File? _image;
  File? _KTP;

  void setImage(String value, File file) {
    if (value == "foto") {
      _image = file;
    } else {
      _KTP = file;
    }
  }

  @override
  void initState() {
    unit(context).then((value) {
      setState(() {
        Listunit = value;
        unitCont.text = value[0]["id"].toString();
      });
    }).catchError((e) {
      print(e);
      toast("Gagal mengambil data unit");
    });
    super.initState();
  }

  // pilihan(value) {
  //   return [
  //     ListTile(
  //         leading: new Icon(Icons.camera),
  //         title: new Text('Camera'),
  //         onTap: () => pickImageFromCamera(getImage(value)).then(
  //               (value) {
  //                 setState(() {
  //                   _image = value;
  //                 });
  //               },
  //             )),
  //     ListTile(
  //       leading: new Icon(Icons.image),
  //       title: new Text('Gallery'),
  //       onTap: () => pickImageFromGallery(getImage(value)).then((value) {
  //         setState(() {
  //           index;
  //           _KTP = value;
  //         });
  //       }),
  //     ),
  //   ];
  // }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: biru,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  80.height,
                  Container(
                    decoration: shadowCard(),
                    width: 500,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Form Registrasi',
                              style: boldTextStyle(size: 24)),
                          30.height,
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                pilihanModal(context, pilihan(
                                  (value) {
                                    setState(() {
                                      setImage("foto", value);
                                    });
                                  },
                                ));
                              },
                              child: CircleAvatar(
                                radius: 70.0,
                                backgroundImage: _image == null
                                    ? const AssetImage('assets/user.png')
                                        as ImageProvider<Object>
                                    : FileImage(_image!)
                                        as ImageProvider<Object>,
                                backgroundColor: Colors.black,
                              ),
                            ),
                          ),
                          30.height,
                          GestureDetector(
                            onTap: () {
                              pilihanModal(context, pilihan(
                                (value) {
                                  setState(() {
                                    setImage("KTP", value);
                                    index = 1;
                                  });
                                },
                              ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      index == 1 ? biru : Colors.red.shade100,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              width: lebar(context) * 0.26,
                              height: tinggi(context) * 0.05,
                              child: Center(
                                child: Text(
                                  index == 1 ? 'Terupload' : 'Upload KTP',
                                  style: const TextStyle(
                                    color: hitam,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          16.height,
                          buildTextField('NIK', NIK),
                          16.height,
                          buildTextField('First Name', firstNameCont),
                          16.height,
                          buildTextField('Last Name', lastNameCont),
                          16.height,
                          buildTextField('Email', emailCont,
                              inputType: TextInputType.emailAddress,
                              email: true),
                          16.height,
                          buildTextField('Password', passwordCont,
                              obscureText: obscureText,
                              isPassword: true, suffixIcononChanged: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          }),
                          16.height,
                          buildTextField(
                              'Sekolah/Perguruan Tinggi', sekolahCont),
                          16.height,
                          buildTextField('Alamat', alamatCont),
                          16.height,
                          dropdownFieldphs(
                            ["Petugas OP", "Tenaga Pendukung"],
                            onChanged: (newValue) {
                              if (newValue == "Tenaga Pendukung") {
                                setState(() {
                                  petugaslapangan = "0";
                                });
                              } else {
                                setState(() {
                                  petugaslapangan = "1";
                                });
                              }
                            },
                          ),
                          petugaslapangan == "1" ? 16.height : Container(),
                          petugaslapangan == "1"
                              ? dropdownFieldphs(
                                  ["PPA", "Pekarya", "PPA POB", "Pekarya POB"],
                                  onChanged: (newValue) {
                                    setState(() {
                                      jabatan = newValue.toString();
                                    });
                                  },
                                )
                              : Container(),
                          16.height,
                          buildTextField('Pendidikan Terakhir', pendidikanCont),
                          16.height,
                          buildTextField('Jurusan', jurusanCont),
                          16.height,
                          datePicker(context, ttlCont),
                          16.height,
                          buildTextField('Domisili', domisiliCont),
                          16.height,
                          dropdownField(
                            Listunit,
                            onChanged: (newValue) {
                              if (newValue is Map) {
                                setState(() {
                                  Dataunit = newValue['id']?.toString() ?? '';
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  30.height,
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: kuning,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 20,
                              offset: const Offset(0, 20))
                        ]),
                    child: Text('Sign Up',
                        style: boldTextStyle(color: hitam, size: 18)),
                  ).onTap(() {
                    if (!_formKey.currentState!.validate()) {
                      showFailPopup(
                          context, "Mohon isi semua field yang wajib");
                    } else {
                      if (!checkValues()) return;

                      daftar(context, {
                        "firstName": firstNameCont.text,
                        "lastName": lastNameCont.text,
                        "email": emailCont.text,
                        "password": passwordCont.text,
                        "sekolah": sekolahCont.text,
                        "alamat": alamatCont.text,
                        "petugas_lapangan": petugaslapangan,
                        "pendidikan_terakhir": pendidikanCont.text,
                        "jurusan": jurusanCont.text,
                        "TTL": ttlCont.text,
                        "domisili": domisiliCont.text,
                        "unit": Dataunit,
                        "foto": _image,
                        "ktp": _KTP,
                        "jabatan": jabatan,
                        "nik": NIK.text,
                      }).then((value) {
                        print(value);
                        if (value is Map) {
                          if (value['status'] == "Success") {
                            showSuccessPopup(context, value['message']);
                            Future.delayed(const Duration(seconds: 2), () {
                              replaceToNextScreen(context, const Login());
                            });
                          } else {
                            showFailPopup(context, value['message']);
                          }
                        } else {
                          showFailPopup(context, "Gagal melakukan registrasi");
                        }
                      }).catchError((e) {
                        print(e);
                        showFailPopup(context, e.toString());
                      });
                    }
                  }),
                  20.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool checkValues() {
    List<String> missing = [];

    if (NIK.text.trim().isEmpty) missing.add("NIK");
    if (firstNameCont.text.trim().isEmpty) missing.add("First Name");
    if (lastNameCont.text.trim().isEmpty) missing.add("Last Name");
    if (emailCont.text.trim().isEmpty) missing.add("Email");
    if (passwordCont.text.trim().isEmpty) missing.add("Password");
    if (sekolahCont.text.trim().isEmpty)
      missing.add("Sekolah/Perguruan Tinggi");
    if (alamatCont.text.trim().isEmpty) missing.add("Alamat");
    if (petugaslapangan.trim().isEmpty) missing.add("Jenis Petugas");
    if (pendidikanCont.text.trim().isEmpty) missing.add("Pendidikan Terakhir");
    if (jurusanCont.text.trim().isEmpty) missing.add("Jurusan");
    if (ttlCont.text.trim().isEmpty) missing.add("TTL");
    if (domisiliCont.text.trim().isEmpty) missing.add("Domisili");

    // pastikan Dataunit berisi id unit, fallback ke controller jika belum di-set
    if (Dataunit.isEmpty) Dataunit = unitCont.text;
    if (Dataunit.trim().isEmpty) missing.add("Unit");

    if (_image == null) missing.add("Foto");
    if (_KTP == null) missing.add("KTP");

    if (missing.isNotEmpty) {
      showFailPopup(context, "Mohon lengkapi: ${missing.join(', ')}");
      return false;
    }
    return true;
  }
}
