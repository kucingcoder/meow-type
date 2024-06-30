import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'login.dart';
import 'dart:convert';
import 'session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  String jenis_kelamin = 'Pilih jenis kelamin';
  final TextEditingController _lahirController = TextEditingController();
  final TextEditingController _negaraController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var headers = {'Cookie': sesi_cookie};

    var url = Uri.parse('https://meow-type.serverku.my.id/info-data-diri');
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var data = jsonResponse['data'];

      _emailController.text = data['Email'];
      _namaController.text = data['Nama'];
      _lahirController.text = data['TanggalLahir'];
      _negaraController.text = data['Negara'];

      setState(() {
        jenis_kelamin = data['JenisKelamin'];
      });
    } else {
      var jsonResponse = json.decode(response.body);
      var errorMessage = jsonResponse['message'];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Gagal Mengambil Info'),
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

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayColor: Colors.orange.withOpacity(0.3),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Meow Type',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Keluar Akun'),
                  content:
                      const Text('Apakah anda ingin keluar dari akun ini?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {Navigator.of(context).pop()},
                      child: const Text('Tidak'),
                    ),
                    TextButton(
                      onPressed: () async {
                        var headers = {'Cookie': sesi_cookie};

                        var url = Uri.parse(
                            'https://meow-type.serverku.my.id/keluar');
                        var response = await http.post(url, headers: headers);

                        if (response.statusCode == 200) {
                          sesi_cookie = "";

                          final SharedPreferences prefs = await _prefs;
                          prefs.remove('sesi-meow-type');

                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                          );
                        } else {
                          var jsonResponse = json.decode(response.body);
                          var errorMessage = jsonResponse['message'];
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Gagal Keluar Akun'),
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
                      },
                      child: const Text('Ya'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                        value: jenis_kelamin,
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
                        onChanged: (String? gender) {
                          if (gender != null) {
                            jenis_kelamin = gender;
                          }
                        },
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
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            context.loaderOverlay.show();

                            if (_formKey.currentState!.validate()) {
                              String email = _emailController.text.trim();
                              String nama = _namaController.text.trim();
                              String lahir = _lahirController.text.trim();
                              String negara = _negaraController.text.trim();

                              var headers = {
                                'Content-Type':
                                    'application/x-www-form-urlencoded',
                                'Cookie': sesi_cookie
                              };
                              var body = {
                                'email': email,
                                'nama': nama,
                                'jenis_kelamin': jenis_kelamin,
                                'tanggal_lahir': lahir,
                                'negara': negara
                              };

                              var url = Uri.parse(
                                  'https://meow-type.serverku.my.id/perbaharui-data-diri');
                              var response = await http.patch(url,
                                  headers: headers, body: body);

                              var jsonResponse = json.decode(response.body);
                              var Message = jsonResponse['message'];

                              if (response.statusCode == 200) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Tersimpan'),
                                    content: Text(Message),
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
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Gagal Menyimpan'),
                                    content: Text(Message),
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
                            "SIMPAN",
                            style: TextStyle(fontSize: 20),
                          ),
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
