import 'package:flutter/material.dart';
import 'package:meow_type/session.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var cameraStatus = await Permission.camera.status;
  var mediaStatus = await Permission.mediaLibrary.status;

  if (!cameraStatus.isGranted) {
    cameraStatus = await Permission.camera.request();
  }

  if (!mediaStatus.isGranted) {
    mediaStatus = await Permission.mediaLibrary.request();
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? sesi = prefs.getString('sesi-meow-type');

  StatefulWidget target;

  if (sesi != null) {
    sesi_cookie = sesi;
    target = const Dashboard();
  } else {
    target = const Login();
  }

  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'ComicNeue',
      primarySwatch: Colors.orange,
    ),
    initialRoute: '/',
    routes: {'/': (context) => target},
  ));
}
