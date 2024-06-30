import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'info_classification.dart';
import 'login.dart';
import 'dart:convert';
import 'session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Classification extends StatefulWidget {
  const Classification({super.key});

  @override
  State<Classification> createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool isCameraReady = false;

  @override
  void initState() {
    super.initState();
    startCamera();
  }

  Future<void> startCamera() async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await cameraController.initialize();
      setState(() {
        isCameraReady = true;
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (!isCameraReady) {
      content = const Center(
          child: CircularProgressIndicator(
        color: Colors.orange,
      ));
    } else {
      content = Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: cameraController.value.aspectRatio,
              child: CameraPreview(cameraController),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: FloatingActionButton(
              onPressed: () async {
                cameraController.pausePreview();

                final picker = ImagePicker();
                final file =
                    await picker.pickImage(source: ImageSource.gallery);

                if (file != null) {
                  context.loaderOverlay.show();

                  var request = http.MultipartRequest(
                    'POST',
                    Uri.parse('https://meow-type.serverku.my.id/klasifikasi'),
                  );

                  request.files.add(
                      await http.MultipartFile.fromPath('gambar', file.path));

                  request.headers['Cookie'] = sesi_cookie;

                  var streamedResponse = await request.send();
                  var response =
                      await http.Response.fromStream(streamedResponse);

                  if (response.statusCode == 200) {
                    var jsonResponse = json.decode(response.body);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => Info_Classification(
                                foto: jsonResponse['data']['foto'],
                                jenis: jsonResponse['data']['info']['jenis'],
                                umur_min: jsonResponse['data']['info']
                                    ['umur_min'],
                                umur_max: jsonResponse['data']['info']
                                    ['umur_max'],
                                harga_min: jsonResponse['data']['info']
                                    ['harga_min'],
                                harga_max: jsonResponse['data']['info']
                                    ['harga_max'],
                                berat_min: jsonResponse['data']['info']
                                    ['berat_min'],
                                berat_max: jsonResponse['data']['info']
                                    ['berat_max'],
                                panjang_min: jsonResponse['data']['info']
                                    ['panjang_min'],
                                panjang_max: jsonResponse['data']['info']
                                    ['panjang_max'],
                                deskripsi_teks: jsonResponse['data']['info']
                                    ['deskripsi_teks'],
                              )),
                    );
                  } else {
                    var jsonResponse = json.decode(response.body);
                    var errorMessage = jsonResponse['message'];
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Gagal Klasifikasi'),
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

                  context.loaderOverlay.hide();
                }
                cameraController.resumePreview();
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              heroTag: 'galery',
              child: const Icon(
                Icons.photo_library,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () async {
                cameraController.takePicture().then((XFile? file) async {
                  if (mounted) {
                    if (file != null) {
                      context.loaderOverlay.show();

                      var request = http.MultipartRequest(
                        'POST',
                        Uri.parse(
                            'https://meow-type.serverku.my.id/klasifikasi'),
                      );

                      request.files.add(await http.MultipartFile.fromPath(
                          'gambar', file.path));

                      request.headers['Cookie'] = sesi_cookie;

                      var streamedResponse = await request.send();
                      var response =
                          await http.Response.fromStream(streamedResponse);

                      if (response.statusCode == 200) {
                        var jsonResponse = json.decode(response.body);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Info_Classification(
                                    foto: jsonResponse['data']['foto'],
                                    jenis: jsonResponse['data']['info']
                                        ['jenis'],
                                    umur_min: jsonResponse['data']['info']
                                        ['umur_min'],
                                    umur_max: jsonResponse['data']['info']
                                        ['umur_max'],
                                    harga_min: jsonResponse['data']['info']
                                        ['harga_min'],
                                    harga_max: jsonResponse['data']['info']
                                        ['harga_max'],
                                    berat_min: jsonResponse['data']['info']
                                        ['berat_min'],
                                    berat_max: jsonResponse['data']['info']
                                        ['berat_max'],
                                    panjang_min: jsonResponse['data']['info']
                                        ['panjang_min'],
                                    panjang_max: jsonResponse['data']['info']
                                        ['panjang_max'],
                                    deskripsi_teks: jsonResponse['data']['info']
                                        ['deskripsi_teks'],
                                  )),
                        );
                      } else {
                        var jsonResponse = json.decode(response.body);
                        var errorMessage = jsonResponse['message'];
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Gagal Klasifikasi'),
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

                      context.loaderOverlay.hide();
                    }
                  }
                });
              },
              backgroundColor: Colors.orange.withOpacity(0.3),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              heroTag: 'photo',
              child: const Icon(
                Icons.camera,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

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
        body: content,
      ),
    );
  }
}
