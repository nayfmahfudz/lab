import 'dart:io';

import 'package:Absen_BBWS/fom.dart';
import 'package:Absen_BBWS/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nb_utils/nb_utils.dart';

Future pilihanModal(BuildContext context, List<Widget> pilihan) {
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: new Column(mainAxisSize: MainAxisSize.min, children: pilihan),
        );
      });
}

List<Widget> pilihan(Function(File)? onImagePicked) {
  return [
    ListTile(
      leading: new Icon(Icons.camera),
      title: new Text('Camera'),
      onTap: () async {
        final file = await pickImageFromCamera();
        if (file != null) onImagePicked?.call(file);
      },
    ),
    ListTile(
      leading: new Icon(Icons.image),
      title: const Text('Gallery'),
      onTap: () async {
        final file = await pickImageFromGallery();
        if (file != null) onImagePicked?.call(file);
      },
    ),
  ];
}

final ImagePicker _picker = ImagePicker();
Future pickImageFromGallery() async {
  print("object");
  final XFile? pickedFile =
      await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}

Future<File?> pickImageFromCamera() async {
  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}

Widget submitButton(BuildContext context, void Function()? onPressed,
    String label, Size? minimumSize) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: minimumSize,
        backgroundColor: kuning,
        foregroundColor: Colors.black,
      ),
      child: Text(label),
    ),
  );
}

Widget datePicker(BuildContext context, ttlCont) {
  return TextFormField(
    controller: ttlCont,
    validator: (value) => validatePassword(value),
    decoration: InputDecoration(
      labelText: 'Tanggal Lahir',
      contentPadding: const EdgeInsets.all(16),
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: hitam),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: hitam),
      ),
    ),
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (pickedDate != null) {
        ttlCont.text = "${pickedDate.toLocal()}".split(' ')[0];
      }
    },
  );
}

Widget progressForm(TextEditingController controller, String hint,
    String satuan, BuildContext context,
    {bool enabled = true}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        padding: const EdgeInsets.only(left: 40.0),
        width: lebar(context) * 0.8,
        child: TextFormField(
            controller: controller,
            keyboardType: enabled ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
                labelText: hint,
                contentPadding: const EdgeInsets.all(16),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: merah),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: hitam),
                ))),
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: Text(satuan,
            style: const TextStyle(
                fontSize: 16, color: hitam, fontWeight: FontWeight.bold)),
      ),
    ],
  );
}

Widget userLogin(TextEditingController namaController) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
    child: TextFormField(
      controller: namaController,
      validator: (input) {
        return validateEmail(input);
      },
      decoration: const InputDecoration(
          hintText: "Email or Phone number",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
    ),
  );
}

Widget passwordLogin(TextEditingController passwordController) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
    child: TextFormField(
      controller: passwordController,
      obscureText: true,
      validator: (input) {
        return validatePassword(input);
      },
      decoration: const InputDecoration(
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none),
    ),
  );
}

Widget buildTextField(String label, TextEditingController controller,
    {bool isPassword = false,
    obscureText = true,
    TextInputType inputType = TextInputType.text,
    VoidCallback? suffixIcononChanged,
    bool email = false}) {
  return TextFormField(
    autocorrect: true,
    controller: controller,
    validator: (input) {
      if (email) {
        return validateEmail(input);
      } else {
        return validatePassword(input);
      }
    },
    obscureText: isPassword ? obscureText : false,
    keyboardType: inputType,
    decoration: InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.all(16),
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: hitam),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: hitam),
      ),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: suffixIcononChanged,
            )
          : null,
    ),
  );
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Field ini wajib diisi';
  }
  if (value.length < 5) {
    return 'Minimal 5 karakter';
  }
  return null; // valid
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Email wajib diisi';
  const pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
      r"[a-zA-Z0-9]+\.[a-zA-Z]+";
  final regex = RegExp(pattern);
  return !regex.hasMatch(value) ? 'Masukkan email yang valid' : null;
}

Widget dropdownFieldphs(
  List list, {
  bool isPassword = false,
  TextInputType inputType = TextInputType.text,
  Function(Object?)? onChanged,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      border: Border.all(color: hitam),
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButtonFormField(
      validator: (value) => value == null ? 'Harap pilih salah satu' : null,
      isExpanded: true,
      items: list.map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value, style: const TextStyle(color: hitam)),
        );
      }).toList(),
      onChanged: onChanged,
      hint: const Text('Select an option'),
    ),
  );
}

Future cekDanKirimLokasi(BuildContext context) async {
  // Cek apakah GPS aktif
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showFailPopup(context, "GPS tidak aktif. Aktifkan lokasi terlebih dahulu.");
    return;
  } else {
    // Jika GPS aktif, lanjutkan ke pengecekan izin
    print("GPS aktif");
  }

  // Cek izin lokasi
  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever ||
      permission == LocationPermission.denied) {
    showFailPopup(
        context, "Izin lokasi ditolak. Tidak dapat mengakses lokasi.");
    return;
  } else {
    // Jika izin lokasi diberikan, lanjutkan ke pengambilan lokasi
    print("Izin lokasi diberikan");
  }

  return true;
}

Widget dropdownProgressDI(
  context,
  List list, {
  bool isPassword = false,
  TextInputType inputType = TextInputType.text,
  Function(String?)? onChanged,
  String? nilai,
  String? hintText,
}) {
  return Container(
    width: lebar(context) * 0.7,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      border: Border.all(color: hitam),
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButtonFormField<String>(
      validator: (value) => value == null ? 'Harap pilih salah satu' : null,
      isExpanded: true,
      items: list.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem(
          value: value.toString(),
          child: Text(value.toString(), style: const TextStyle(color: hitam)),
        );
      }).toList(),
      value: nilai,
      onChanged: onChanged,
      hint: Text(hintText ?? 'Select an option'),
    ),
  );
}

Widget dropdownProgress(
  context,
  List list, {
  bool isPassword = false,
  TextInputType inputType = TextInputType.text,
  Function(String?)? onChanged,
  String? nilai,
  String? hintText,
}) {
  return Container(
    width: lebar(context) * 0.7,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      border: Border.all(color: hitam),
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButtonFormField<String>(
      validator: (value) => value == null ? 'Harap pilih salah satu' : null,
      isExpanded: true,
      items: list.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem(
          value: value['id'].toString(),
          child: Text(value['nama'].toString(),
              style: const TextStyle(color: hitam)),
        );
      }).toList(),
      value: nilai,
      onChanged: onChanged,
      hint: Text(hintText ?? 'Select an option'),
    ),
  );
}

Widget dropdownField(
  List list, {
  bool isPassword = false,
  TextInputType inputType = TextInputType.text,
  Function(Object?)? onChanged,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      border: Border.all(color: hitam),
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButtonFormField(
      validator: (value) => value == null ? 'Harap pilih salah satu' : null,
      isExpanded: true,
      items: list.map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value['nama_unit'], style: const TextStyle(color: hitam)),
        );
      }).toList(),
      // value: Dataunit,
      onChanged: onChanged,

      hint: const Text('Select an option'),
    ),
  );
}

Widget profileCard(BuildContext context, {Widget? profileView}) {
  return Container(
    height: tinggi(context) * 0.22,
    width: lebar(context),
    decoration: const BoxDecoration(
      boxShadow: [
        BoxShadow(
            color: hitam,
            spreadRadius: 0.1,
            blurRadius: 2,
            offset: const Offset(0, 2))
      ],
      color: kuning,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: Column(
      children: [
        70.height,
        if (profileView != null) profileView,
      ],
    ),
  );
}

Decoration shadowCard() {
  return BoxDecoration(
    color: putih,
    boxShadow: [
      BoxShadow(
          color: hitam,
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 5))
    ],
    borderRadius: const BorderRadius.all(Radius.circular(16)),
  );
}

void loadingPopup(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoadingAnimationWidget.fourRotatingDots(
          color: kuning,
          size: 200,
        );
      });
}

void showSuccessPopup(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: transparentColor,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: tinggi(context) * 0.12,
                  width: lebar(context) * 0.8,
                  decoration: const BoxDecoration(
                    color: putih,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  // padding: EdgeInsets.all(20),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 85),
                    ],
                  ),
                ),
                Container(
                  height: tinggi(context) * 0.15,
                  width: lebar(context) * 0.8,
                  decoration: const BoxDecoration(
                    color: biru,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(message,
                          style: const TextStyle(
                              fontSize: 18,
                              color: putih,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
}

void showMaintenancePopup(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: transparentColor,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: tinggi(context) * 0.15,
                  width: lebar(context) * 0.8,
                  decoration: const BoxDecoration(
                    color: putih,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  // padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/road-block.png',
                          height: 120, width: 120, fit: BoxFit.cover),
                    ],
                  ),
                ),
                Container(
                  height: tinggi(context) * 0.15,
                  width: lebar(context) * 0.8,
                  decoration: const BoxDecoration(
                    color: biru,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text("Fitur ini sedang dalam perbaikan",
                          style: const TextStyle(
                              fontSize: 18,
                              color: putih,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
}

ambilImageFromCamera() async {
  // Implementasi untuk mengambil gambar dari kamera
  // Misalnya menggunakan ImagePicker
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  return pickedFile != null ? File(pickedFile.path) : null;
}

void showFailPopup(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: transparentColor,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: tinggi(context) * 0.12,
                  width: lebar(context) * 0.8,
                  decoration: const BoxDecoration(
                    color: putih,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  // padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.dangerous, color: Colors.red[400], size: 85),
                    ],
                  ),
                ),
                Container(
                  height: tinggi(context) * 0.15,
                  width: lebar(context) * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(message,
                          style: const TextStyle(
                              fontSize: 18,
                              color: putih,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
}
