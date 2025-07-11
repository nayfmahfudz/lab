import 'dart:io';

import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/login.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  var Dataunit = "";
  var petugaslapangan = "";
  List Listunit = [];
  File? _image;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
                    decoration: BoxDecoration(
                        color: putih,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 20,
                              offset: const Offset(0, 20))
                        ]),
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
                                _pickImageFromCamera();
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
                          buildTextField('First Name', firstNameCont),
                          16.height,
                          buildTextField('Last Name', lastNameCont),
                          16.height,
                          buildTextField('Email', emailCont,
                              inputType: TextInputType.emailAddress,
                              email: true),
                          16.height,
                          buildTextField('Password', passwordCont,
                              isPassword: true),
                          16.height,
                          buildTextField('Sekolah', sekolahCont),
                          16.height,
                          buildTextField('Alamat', alamatCont),
                          16.height,
                          dropdownFieldphs(
                            ["Petugas OP", "PHS"],
                            onChanged: (newValue) {
                              if (newValue == "Petugas OP") {
                                setState(() {
                                  petugaslapangan = "1";
                                });
                              } else {
                                setState(() {
                                  petugaslapangan = "0";
                                });
                              }
                              print(petugaslapangan);
                            },
                          ),
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
                      }).then((value) {
                        print(value);
                        if (value is Map) {
                          if (value['status'] == "Success") {
                            showSuccessPopup(context, value['message']);
                            Future.delayed(const Duration(seconds: 2), () {
                              finish(context);
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
}
