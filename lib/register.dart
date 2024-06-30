import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'dashboard.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sandiController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  String jenis_kelamin = "";
  final TextEditingController _lahirController = TextEditingController();
  final TextEditingController _negaraController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayColor: Colors.orange.withOpacity(0.3),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: SizedBox(
                          width: 160,
                          height: 160,
                          child: Image.asset('images/illustration1.png'),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(0),
                      child: Center(
                        child: Text(
                          'MEOW TYPE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: Text(
                          'Bergabunglah Bersama Kami',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _emailController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Masukan email'),
                          EmailValidator(errorText: 'Email tidak Valid')
                        ]).call,
                        decoration: const InputDecoration(
                            hintText: 'meow@meow.com',
                            labelText: 'Email',
                            prefixIcon: Icon(
                              Icons.mail,
                            ),
                            floatingLabelStyle: TextStyle(color: Colors.orange),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange, width: 3)),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _sandiController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Masukan sandi'),
                          MinLengthValidator(8,
                              errorText: 'Kata sandi minimal 8 karakter')
                        ]).call,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            hintText: '********',
                            labelText: 'Sandi',
                            prefixIcon: const Icon(
                              Icons.key,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            floatingLabelStyle:
                                const TextStyle(color: Colors.orange),
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange, width: 3)),
                            border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _namaController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Masukan nama'),
                          MinLengthValidator(4,
                              errorText: 'Nama minimal 4 karakter')
                        ]).call,
                        decoration: const InputDecoration(
                            hintText: 'dodi',
                            labelText: 'Nama',
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                            floatingLabelStyle: TextStyle(color: Colors.orange),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange, width: 3)),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: DropdownButtonFormField<String>(
                        onChanged: (String? gender) {
                          if (gender != null) {
                            jenis_kelamin = gender;
                          }
                        },
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Pilih jenis kelamin'),
                          PatternValidator(r'^(laki - laki|perempuan)$',
                              errorText: 'Pilih jenis kelamin')
                        ]).call,
                        items: <String>[
                          'Pilih jenis kelamin',
                          'laki - laki',
                          'perempuan'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: 'Pilih jenis kelamin',
                        decoration: const InputDecoration(
                            hintText: 'Pilih jenis kelamin',
                            labelText: 'Jenis Kelamin',
                            prefixIcon: Icon(
                              Icons.male,
                            ),
                            floatingLabelStyle: TextStyle(color: Colors.orange),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange, width: 3)),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _lahirController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Pilih tanggal lahir'),
                        ]).call,
                        decoration: const InputDecoration(
                            hintText: 'Pilih tanggal lahir',
                            labelText: 'Tanggal Lahir',
                            prefixIcon: Icon(
                              Icons.calendar_month,
                            ),
                            floatingLabelStyle: TextStyle(color: Colors.orange),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange, width: 3)),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            )),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100));

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              _lahirController.text = formattedDate;
                            });
                          } else {}
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _negaraController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Masukan nama negara'),
                          MinLengthValidator(3,
                              errorText: 'Nama negara minimal 3 karakter')
                        ]).call,
                        decoration: const InputDecoration(
                            hintText: 'indonesia',
                            labelText: 'Negara',
                            prefixIcon: Icon(
                              Icons.flag,
                            ),
                            floatingLabelStyle: TextStyle(color: Colors.orange),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orange, width: 3)),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            context.loaderOverlay.show();

                            if (_formKey.currentState!.validate()) {
                              String email = _emailController.text.trim();
                              String sandi = _sandiController.text.trim();
                              String nama = _namaController.text.trim();
                              String lahir = _lahirController.text.trim();
                              String negara = _negaraController.text.trim();

                              var headers = {
                                'Content-Type':
                                    'application/x-www-form-urlencoded'
                              };
                              var body = {
                                'email': email,
                                'sandi': sandi,
                                'nama': nama,
                                'jenis_kelamin': jenis_kelamin,
                                'tanggal_lahir': lahir,
                                'negara': negara
                              };

                              var url = Uri.parse(
                                  'https://meow-type.serverku.my.id/daftar');
                              var response = await http.post(url,
                                  headers: headers, body: body);

                              if (response.statusCode == 200) {
                                String? cookie = response.headers['set-cookie'];
                                sesi_cookie =
                                    cookie!.substring(0, cookie.length - 10);

                                final SharedPreferences prefs = await _prefs;
                                prefs.setString('sesi-meow-type', sesi_cookie);

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => const Dashboard()),
                                );
                              } else {
                                var jsonResponse = json.decode(response.body);
                                var errorMessage = jsonResponse['message'];
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Gagal Membuat Akun'),
                                    content: Text(errorMessage),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                            context.loaderOverlay.hide();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white),
                          child: const Text(
                            "BUAT AKUN BARU",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Sudah punya akun?"),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => const Login()),
                                );
                              },
                              child: const Text(
                                "Masuk",
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
