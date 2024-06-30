import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'register.dart';
import 'dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sandiController = TextEditingController();

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
                          'Selamat Datang Kembali',
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
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            context.loaderOverlay.show();

                            if (_formKey.currentState!.validate()) {
                              String email = _emailController.text.trim();
                              String sandi = _sandiController.text.trim();

                              var headers = {
                                'Content-Type':
                                    'application/x-www-form-urlencoded'
                              };
                              var body = {'email': email, 'sandi': sandi};

                              var url = Uri.parse(
                                  'https://meow-type.serverku.my.id/masuk');
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
                                    title: const Text('Gagal Masuk'),
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
                            "MASUK",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Belum punya akun?"),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => const Register()),
                                );
                              },
                              child: const Text(
                                "Daftar",
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
