import 'dart:convert';
import 'dart:ffi';
import 'package:Absen_BBWS/component/component.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

final ImagePicker _picker = ImagePicker();
Future daftar(BuildContext context, Map user) async {
  try {
    FormData formData = FormData.fromMap({
      "firstName": user["firstName"],
      "lastName": user["lastName"],
      "password": user["password"],
      "sekolah": user["sekolah"],
      "alamat": user["alamat"],
      "petugas_lapangan": user["petugas_lapangan"],
      "email": user["email"],
      "pendidikan_terakhir": user["pendidikan_terakhir"],
      "jurusan": user["jurusan"],
      "TTL": user["TTL"],
      "domisili": user["domisili"],
      "unit": user["unit"],
      "foto": user["foto"] != null
          ? MultipartFile.fromFileSync(user["foto"].path,
              filename: user["foto"].path.split('/').last)
          : null,
    });
    var response = await Dio().post('$url/users',
        data: formData,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          "Accept": "application/json",
        }));
    if (response.statusCode == 200) {
      return response.data;
    }
  } on DioError catch (e) {
    return e.response?.data;
  }
}

Future login(BuildContext context, Map data) async {
  try {
    var response = await Dio().post('$url/users/login',
        data: jsonEncode(data),
        options: Options(headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }));
    return response.data;
  } on DioError catch (e) {
    // if (e.response?.statusCode != 200) {
    return e.response?.data;
    // }
  }
}

Future daerah(BuildContext context, String daerah, Int kode) async {
  try {
    var UrlDaerah = '';
    if (daerah == "Kecamatan") {
      UrlDaerah =
          'https://ibnux.github.io/data-indonesia/kecamatan/${kode}.json';
    } else {
      var response = await Dio().get('$url/daerah',
          queryParameters: {"daerah": daerah, "kode": kode},
          options: Options(headers: {
            "Content-Type": "application/json;charset=UTF-8",
          }));
      return response.data;
    }
    var response = await Dio().get('$url/units',
        options: Options(
            headers: {"Content-Type": "application/json;charset=UTF-8"}));
    return response.data;
  } on DioError catch (e) {
    // if (e.response?.statusCode != 200) {
    //   return false;
    // }
  }
}

Future unit(BuildContext context) async {
  try {
    var response = await Dio().get('$url/units',
        options: Options(
            headers: {"Content-Type": "application/json;charset=UTF-8"}));
    return response.data;
  } on DioError catch (e) {
    // if (e.response?.statusCode != 200) {
    //   return false;
    // }
  }
}

Future absenmasuk(BuildContext context, Map user) async {
  try {
    FormData formData = FormData.fromMap(user.cast<String, dynamic>());
    var response = await Dio().post('$url/absenmasuk',
        data: formData,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          "Accept": "application/json",
        }));
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Failed to submit absenmasuk: ${response.statusMessage}");
    }
  } on DioError catch (e) {
    if (e.response != null) {
      return e.response?.data;
    } else {
      return {"error": e.message};
    }
  } catch (e) {
    return {"error": "Unexpected error occurred"};
  }
}

Future progressFetch(BuildContext context, Map data) async {
  try {
    FormData formData = FormData.fromMap(data.cast<String, dynamic>());
    var response = await Dio().post('$url/progress',
        data: formData,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          "Accept": "application/json",
        }));
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Failed to submit absenmasuk: ${response.statusMessage}");
    }
  } on DioError catch (e) {
    if (e.response != null) {
      return e.response?.data;
    } else {
      return {"error": e.message};
    }
  } catch (e) {
    return {"error": "Unexpected error occurred"};
  }
}

Future absenkeluar(BuildContext context, Map user) async {
  try {
    FormData formData = FormData.fromMap(user.cast<String, dynamic>());
    var response = await Dio().post('$url/absenkeluar',
        data: formData,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          "Accept": "application/json",
        }));
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception(
          "Failed to submit absenkeluar: ${response.statusMessage}");
    }
  } on DioError catch (e) {
    if (e.response != null) {
      return e.response?.data;
    } else {
      return {"error": e.message};
    }
  } catch (e) {
    return {"error": "Unexpected error occurred"};
  }
}

Future progress(BuildContext context, int currentPorgress) async {
  photo = await _picker.pickImage(source: ImageSource.camera);
  if (photo != null) {
    progressFetch(context, {
      "progress_1": currentPorgress == 0
          ? MultipartFile.fromFileSync(photo!.path,
              filename: photo?.path.split('/').last)
          : null,
      "progress_50": currentPorgress == 1
          ? MultipartFile.fromFileSync(photo!.path,
              filename: photo?.path.split('/').last)
          : null,
      "progress_100": currentPorgress == 2
          ? MultipartFile.fromFileSync(photo!.path,
              filename: photo?.path.split('/').last)
          : null,
      "idUser": user["id"],
    }).then((onValue) => {
          if (onValue["status"] == "Success")
            {showSuccessPopup(context, onValue["message"])}
          else
            {showFailPopup(context, onValue["message"])}
        });
  }
  Future.delayed(const Duration(seconds: 3), () {
    finish(context);
  });
  photo = null;
}

Future absen(BuildContext context, String absen) async {
  final prefs = await SharedPreferences.getInstance();
  await Geolocator.requestPermission();
  permission = await Geolocator.checkPermission();
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  photo = await _picker.pickImage(source: ImageSource.camera);
  if (absen == "masuk" && photo != null) {
    absenmasuk(context, {
      "latitude": position.latitude.toString(),
      "longtitude": position.longitude.toString(),
      "created": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      "foto": photo != null
          ? MultipartFile.fromFileSync(photo!.path,
              filename: photo?.path.split('/').last)
          : null,
      "idUser": user["id"],
    }).then((onValue) => {
          if (onValue["status"] == "Success")
            {
              masuk = DateFormat("HH:mm").format(DateTime.now()).toString(),
              prefs.setString("masuk", masuk),
              showSuccessPopup(context, onValue["message"])
            }
          else
            {showFailPopup(context, onValue["message"])}
        });
  } else if (absen == "keluar" && photo != null) {
    absenkeluar(context, {
      "latitude": position.latitude.toString(),
      "longtitude": position.longitude.toString(),
      "created": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      "foto": photo != null
          ? MultipartFile.fromFileSync(photo!.path,
              filename: photo?.path.split('/').last)
          : null,
      "idUser": user["id"],
    }).then((onValue) => {
          if (onValue["status"] == "Success")
            {
              keluar = DateFormat("HH:mm").format(DateTime.now()).toString(),
              prefs.setString("keluar", keluar),
              showSuccessPopup(context, onValue["message"])
            }
          else
            {showFailPopup(context, onValue["message"])}
        });
  }
  Future.delayed(const Duration(seconds: 3), () {
    finish(context);
  });
  photo = null;
}

Future<void> loadJson() async {
  String jsonString = await rootBundle.loadString("assets/jawatimur.json");
  jawaTimur = jsonDecode(jsonString) ?? [];
}

Future cekData(idUser) async {
  await Dio()
      .get('$url/cekabsen',
          queryParameters: {"idUser": idUser.toString()},
          options: Options(headers: {
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
          }))
      .then((onValue) {
    if (onValue.data["status"] == "Success" &&
        onValue.data["data"]["progress"] != null &&
        onValue.data["data"]["progress"] != "null") {
      if (onValue.data["data"]["masuk"] != null &&
          onValue.data["data"]["masuk"].isNotEmpty) {
        DateTime parsed = DateTime.parse(
            onValue.data["data"]["masuk"]["createdAt"].toString());
        masuk = DateFormat('HH:mm').format(parsed);
      }
      if (onValue.data["data"]["keluar"] != null &&
          onValue.data["data"]["keluar"].isNotEmpty) {
        DateTime parsed = DateTime.parse(
            onValue.data["data"]["keluar"]["createdAt"].toString());
        keluar = DateFormat('HH:mm').format(parsed);
      }
      currentStep = int.parse(onValue.data["data"]["progress"].toString());
    }
  }).catchError((e) {});
}
