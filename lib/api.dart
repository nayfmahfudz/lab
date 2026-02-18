import 'dart:convert';
import 'dart:io';
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
    if (response.statusCode == 201) {
      return response.data;
    }
  } on DioError catch (e) {
    print(e.response?.data);
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
  } on DioError {
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
  } on DioError {
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

Future tmaFetch(BuildContext context, Map data, {String? id}) async {
  try {
    FormData formData = FormData.fromMap(data.cast<String, dynamic>());
    Response response;
    if (id != null && id != "null") {
      response = await Dio().put('$url/tma/$id',
          data: formData,
          options: Options(headers: {
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
          }));
    } else {
      response = await Dio().post('$url/tma',
          data: formData,
          options: Options(headers: {
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
          }));
    }
    print(response.data);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Failed to submit absenmasuk: ${response.statusMessage}");
    }
  } on DioError catch (e) {
    if (e.response != null) {
      return e.message;
    } else {
      return e.message;
    }
  } catch (e) {
    return e.toString();
  }
}

Future progressFetch(BuildContext context, Map data, {String? id}) async {
  try {
    FormData formData = FormData.fromMap(data.cast<String, dynamic>());
    Response response;
    print("@@0");
    if (id != null && id != "null") {
      print("@@1");
      response = await Dio().put('$url/progress/$id',
          data: formData,
          options: Options(headers: {
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
          }));
    } else {
      response = await Dio().post('$url/progress',
          data: formData,
          options: Options(headers: {
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
          }));
      print(response.data);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Failed to submit absenmasuk: ${response.statusMessage}");
    }
  } on DioError catch (e) {
    if (e.response != null) {
      return {
        "message": e.response?.statusMessage ?? "DioError without response"
      };
    }
  } catch (e) {
    return e.toString();
  }
}

Future getHistory() async {
  try {
    // Mengambil data history TMA berdasarkan user id
    var response = await Dio().get('$url/tma',
        queryParameters: {
          "idUser": user["id"].toString(),
          "tanggal": DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }));
    print(response.data);
    if (response.statusCode == 200 && response.data["status"] == "Success") {
      return response.data;
    } else {
      response.data;
    }
  } catch (e) {
    print("Error fetching history: $e");
    return {"status": "Fail", "message": e.toString()};
  }
}

Future laporTMA(BuildContext context, Map data) async {
  try {
    // Persiapkan data untuk Multipart
    Map<String, dynamic> requestData = Map<String, dynamic>.from(data);

    // Convert File objects to MultipartFile
    for (var key in requestData.keys.toList()) {
      if (key.startsWith("foto_TMA") && requestData[key] is File) {
        File file = requestData[key];
        requestData[key] = MultipartFile.fromFileSync(file.path,
            filename: file.path.split('/').last);
      }
    }

    requestData["idUser"] = user["id"];
    requestData["created"] =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

    // Menggunakan endpoint progress atau endpoint khusus TMA jika ada
    // Disini kita gunakan progressFetch karena strukturnya mirip
    return tmaFetch(context, requestData);
  } catch (e) {
    print("Error laporTMA: $e");
    return {"status": "Fail", "message": e.toString()};
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

Future progress(BuildContext context, int currentPorgress, Map data,
    {String? id}) async {
  photo = await _picker.pickImage(source: ImageSource.camera);

  if (photo != null) {
    // Gabungkan data tambahan ke dalam Map data
    Map<String, dynamic> requestData = Map<String, dynamic>.from(data);
    for (var key in requestData.keys.toList()) {
      if (key.startsWith("foto_TMA") && requestData[key] is File) {
        File file = requestData[key];
        requestData[key] = MultipartFile.fromFileSync(file.path,
            filename: file.path.split('/').last);
      }
    }
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

    return progressFetch(context, requestData, id: id).then((onValue) {
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
        ruas = onValue.data["data"]["progress"];
      }
    }
  }).catchError((e) {});
}
