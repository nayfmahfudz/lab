import 'dart:convert';
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
Future edit(BuildContext context, Map<String, dynamic> user) async {
  try {
    FormData formData = FormData.fromMap(user);
    var response = await Dio().put('$url/users',
        data: formData,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          "Accept": "application/json",
        }));
    print(response.data);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      showSuccessPopup(context, response.data["message"]);
      user = response.data["data"];
      prefs.setString("user", jsonEncode(user));

      return user;
    } else
      return null;
  } on DioError catch (e) {
    showFailPopup(context, e.response?.data["message"]);
    return null;
  }
}

Future daftar(BuildContext context, Map user) async {
  try {
    // Simplified: convert file fields to MultipartFile if present, and remove nulls
    Map<String, dynamic> payload = Map<String, dynamic>.from(user);
    for (final key in ['foto', 'ktp']) {
      final file = user[key];
      if (file != null) {
        payload[key] = MultipartFile.fromFileSync(file.path,
            filename: file.path.split('/').last);
      }
    }
    payload.removeWhere((_, v) => v == null);
    FormData formData = FormData.fromMap(payload);
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
    print("Sss");
    var response = await Dio().post('$url/users/login',
        data: jsonEncode(data),
        options: Options(headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }));
    print(response.data);
    return response.data;
  } on DioError catch (e) {
    // if (e.response?.statusCode != 200) {
    return e.response?.data;
    // }
  }
}

Future daerah(BuildContext context, String daerah, int kode) async {
  try {
    var UrlDaerah =
        'https://ibnux.github.io/data-indonesia/${daerah}/${kode}.json';
    var response = await Dio().get(UrlDaerah,
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

Future progress(BuildContext context, int currentPorgress, Map data) async {
  photo = await _picker.pickImage(source: ImageSource.camera);
  print(data);
  if (photo != null) {
    // Gabungkan data tambahan ke dalam Map data
    Map<String, dynamic> requestData = Map<String, dynamic>.from(data);
    if (currentPorgress == 0) {
      requestData["progress_1"] = MultipartFile.fromFileSync(photo!.path,
          filename: photo?.path.split('/').last);
    } else if (currentPorgress == 1) {
      requestData["progress_50"] = MultipartFile.fromFileSync(photo!.path,
          filename: photo?.path.split('/').last);
    } else if (currentPorgress == 2) {
      requestData["progress_100"] = MultipartFile.fromFileSync(photo!.path,
          filename: photo?.path.split('/').last);
    }
    requestData["idUser"] = user["id"];

    return progressFetch(context, requestData).then((onValue) {
      return onValue;
    });
  }
  photo = null;
}

Future absen(BuildContext context, String absen) async {
  final prefs = await SharedPreferences.getInstance();
  await Geolocator.requestPermission();
  permission = await Geolocator.checkPermission();
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  finish(context);
  photo = await _picker.pickImage(source: ImageSource.camera);
  if (absen == "masuk" && photo != null) {
    absenmasuk(context, {
      "latitude": position.latitude.toString(),
      "longtitude": position.longitude.toString(),
      "created": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      "absen": photo != null
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
      "absen": photo != null
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
  photo = null;
}

Future<void> loadJsonDI() async {
  String jsonString = await rootBundle.loadString("assets/DI.json");
  final prefs = await SharedPreferences.getInstance();
  di = jsonDecode(jsonString) ?? [];
  valueDI = (prefs.getString("valueDI") == null ||
          prefs.getString("valueDI")!.isEmpty)
      ? di[0]
      : jsonDecode(prefs.getString("valueDI").toString()).toString();
}

Future<void> loadJson() async {
  String jsonString = await rootBundle.loadString("assets/jawatimur.json");
  final prefs = await SharedPreferences.getInstance();
  jawaTimur = jsonDecode(jsonString) ?? [];
  String? valueKotaPref = prefs.getString("valueKota");
  print(valueKotaPref);
  valueKota = (valueKotaPref == null || valueKotaPref.isEmpty)
      ? jawaTimur[0]['id']
      : jsonDecode(valueKotaPref).toString();

  if (prefs.getString("kecamatan") != null) {
    kecamatan = jsonDecode(prefs.getString("kecamatan")!).toList();
    prefs.getString("valuekecamatan") != null
        ? valueKecamatan =
            jsonDecode(prefs.getString("valuekecamatan").toString())
        : valueKecamatan =
            kecamatan.isNotEmpty ? kecamatan[0]['id'].toString() : "";
  }
  if (prefs.getString("kelurahan") != null) {
    kelurahan = jsonDecode(prefs.getString("kelurahan")!).toList();
    prefs.getString("valuekelurahan") != null
        ? valueKelurahan =
            jsonDecode(prefs.getString("valuekelurahan").toString())
        : valueKelurahan =
            kelurahan.isNotEmpty ? kelurahan[0]['id'].toString() : "";
  }
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
    if (onValue.data["status"] == "Success") {
      print(onValue.data);
      if (onValue.data["data"]["masuk"] != null &&
          onValue.data["data"]["masuk"].isNotEmpty) {
        DateTime parsed = DateTime.parse(
                onValue.data["data"]["masuk"]["createdAt"].toString())
            .toLocal();
        masuk = DateFormat('HH:mm').format(parsed);
      }
      if (onValue.data["data"]["keluar"] != null &&
          onValue.data["data"]["keluar"].isNotEmpty) {
        DateTime parsed = DateTime.parse(
                onValue.data["data"]["keluar"]["createdAt"].toString())
            .toLocal();
        keluar = DateFormat('HH:mm').format(parsed);
      }
      if (onValue.data["data"]["progress"] != null &&
          onValue.data["data"]["progress"] != "null") {
        currentStep = int.parse(onValue.data["data"]["progress"].toString());
      }
      if (onValue.data["data"]["progress"] == null ||
          onValue.data["data"]["progress"] == "null") {
        currentStep = 0;
      }
    }
  }).catchError((e) {});
}
