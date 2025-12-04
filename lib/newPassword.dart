import 'package:Absen_BBWS/api.dart';
import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  // Controllers
  final TextEditingController passwordCont = TextEditingController();
  final TextEditingController newPasswordCont = TextEditingController();
  final TextEditingController confirmPasswordCont = TextEditingController();

  // Obscure flags for each field
  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    passwordCont.dispose();
    newPasswordCont.dispose();
    confirmPasswordCont.dispose();
    super.dispose();
  }

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
                              Text('Ubah Password',
                                  style: boldTextStyle(size: 24)),
                              16.height,
                              // Current password
                              buildTextField(
                                'Password',
                                passwordCont,
                                obscureText: obscureCurrent,
                                isPassword: true,
                                suffixIcononChanged: () {
                                  setState(() {
                                    obscureCurrent = !obscureCurrent;
                                  });
                                },
                              ),
                              16.height,
                              // New password
                              buildTextField(
                                'Password baru',
                                newPasswordCont,
                                obscureText: obscureNew,
                                isPassword: true,
                                suffixIcononChanged: () {
                                  setState(() {
                                    obscureNew = !obscureNew;
                                  });
                                },
                              ),
                              16.height,
                              // Confirm password
                              buildTextField(
                                'Konfirmasi Password',
                                confirmPasswordCont,
                                obscureText: obscureConfirm,
                                isPassword: true,
                                suffixIcononChanged: () {
                                  setState(() {
                                    obscureConfirm = !obscureConfirm;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      30.height,
                      GestureDetector(
                        onTap: () async {
                          final Map<String, dynamic> data = {
                            'id': user['id'].toString(),
                            'passwordOld': user['password'].toString(),
                            'password': passwordCont.text,
                            'new_password': newPasswordCont.text,
                            'confirm_password': confirmPasswordCont.text,
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
