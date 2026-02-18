import 'dart:io';

import 'package:Absen_BBWS/ProfileInfo.dart';
import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/login.dart';
import 'package:Absen_BBWS/newPassword.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Absen_BBWS/AppWidget.dart';

class ProfileScreen extends StatefulWidget {
  static String tag = '/ProfileScreen';

  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  File? imageFile;
  @override
  Widget build(BuildContext context) {
    Widget profileView() {
      return Container(
        width: lebar(context) * 0.93,
        height: tinggi(context) * 0.4,
        decoration: shadowCard(),
        padding: EdgeInsets.only(left: 30, right: 16),
        child: Column(
          children: [
            Container(
              height: tinggi(context) * 0.12,
              padding: EdgeInsets.only(top: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      pilihanModal(context, pilihan((value) {
                        setState(() {
                          imageFile = value;
                        });
                      }));
                    },
                    child: Image.network("$url/" + user["foto"].toString(),
                            errorBuilder: (context, error, stackTrace) =>
                                CircleAvatar(
                                    radius: 40.0,
                                    backgroundImage:
                                        const AssetImage('assets/user.png')
                                            as ImageProvider<Object>),
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress == null
                                    ? child
                                    : CircleAvatar(
                                        radius: 40.0,
                                        backgroundImage:
                                            const AssetImage('assets/user.png')
                                                as ImageProvider<Object>),
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover)
                        .cornerRadiusWithClipRRect(40),
                  ),
                  30.width,
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user["firstName"] + " " + user["lastName"],
                          style: primaryTextStyle(),
                        ),
                        2.height,
                        Text(user["email"], style: primaryTextStyle()),
                      ],
                    ),
                  )
                ],
              ),
            ),
            16.height,
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Instansi', style: secondaryTextStyle()),
                      15.height,
                      Text('Unit', style: secondaryTextStyle()),
                      15.height,
                      Text('Jabatan', style: secondaryTextStyle()),
                    ],
                  ),
                  45.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('BBWS BRANTAS', style: boldTextStyle(size: 16)),
                      15.height,
                      Text(user["unitObj"]["nama_unit"] ?? '',
                          style: boldTextStyle(size: 16)),
                      15.height,
                      Text(user["jabatan"], style: boldTextStyle(size: 16)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Container(
                height: tinggi(context) * 0.12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Masuk', style: secondaryTextStyle()),
                        4.height,
                        Text('0', style: boldTextStyle(size: 16)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Absen', style: secondaryTextStyle()),
                        4.height,
                        Text('0', style: boldTextStyle(size: 16)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Izin', style: secondaryTextStyle()),
                        4.height,
                        Text('0', style: boldTextStyle(size: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget options() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: shadowCard(),
          child: Column(
            children: [
              settingItem(context, 'Notifications', onTap: () {
                showMaintenancePopup(context);
              },
                  leading: const Icon(MaterialIcons.notifications_none),
                  detail: const SizedBox()),
              const Divider(
                color: Colors.grey,
                height: 12,
                thickness: 1,
              ),
              settingItem(context, 'Password', onTap: () {
                navigateToNextScreen(context, const Password());
              },
                  leading: const Icon(MaterialIcons.vpn_key),
                  detail: const SizedBox()),
              const Divider(
                color: Colors.grey,
                height: 12,
                thickness: 1,
              ),
              settingItem(context, 'Profile Info', onTap: () {
                navigateToNextScreen(context, const Edit());
              },
                  leading: const Icon(MaterialIcons.person_outline),
                  detail: const SizedBox()),
              const Divider(
                color: Colors.grey,
                height: 12,
                thickness: 1,
              ),
              settingItem(context, 'Log Out', onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("user", "");
                replaceToNextScreen(context, const Login());
              },
                  leading: const Icon(MaterialIcons.logout),
                  detail: const SizedBox(),
                  textColor: hitam),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: biru,
      body: Column(
        children: [
          Stack(
            children: [
              profileCard(
                context,
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      60.height,
                      profileView(),
                    ],
                  )),
            ],
          ),
          ContainerX(
            mobile: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  options(),
                ],
              ),
            ),
            web: Column(
              children: [
                profileView(),
                const Divider(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: options(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
