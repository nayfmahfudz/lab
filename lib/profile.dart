import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/login.dart';
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

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget profileView() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network("$url/" + user["foto"],
                      height: 70, width: 70, fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(40),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user["firstName"] + " " + user["lastName"],
                    style: primaryTextStyle(),
                  ),
                  2.height,
                  Text(user["email"], style: primaryTextStyle()),
                ],
              )
            ],
          ),
        ],
      ).paddingAll(16);
    }

    Widget options() {
      return Column(
        children: [
          settingItem(context, 'Notifications',
              onTap: () {},
              leading: const Icon(MaterialIcons.notifications_none),
              detail: const SizedBox()),
          settingItem(context, 'Settings',
              onTap: () {},
              leading: const Icon(MaterialIcons.info_outline),
              detail: const SizedBox()),
          settingItem(context, 'Log Out', onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("user", "");
            replaceToNextScreen(context, const Login());
          },
              leading: const Icon(MaterialIcons.logout),
              detail: const SizedBox(),
              textColor: hitam),
        ],
      );
    }

    return Scaffold(
      backgroundColor: biru,
      body: ContainerX(
        mobile: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              profileView(),
              const Divider(color: hitam, height: 8)
                  .paddingOnly(top: 4, bottom: 4),
              options(),
            ],
          ),
        ),
        web: Column(
          children: [
            profileView(),
            const Divider(height: 8).paddingOnly(top: 4, bottom: 4),
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
    );
  }
}
