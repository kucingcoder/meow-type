import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'info.dart';
import 'login.dart';
import 'dart:convert';
import 'session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Widget> riwayat = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var headers = {'Cookie': sesi_cookie};

    var url = Uri.parse('https://meow-type.serverku.my.id/daftar-riwayat');
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var data = jsonResponse['data'];

      if (data != null) {
        List<dynamic> info = jsonResponse['data'];

        setState(() {
          riwayat = info.map((item) {
            String foto = item['foto'];
            String jenis = item['jenis'];
            String waktu = item['waktu'];

            return Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.orange.withAlpha(70),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Info(
                          gambar: 'https://meow-type.serverku.my.id/foto/$foto',
                          kucing: jenis,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: SizedBox(
                      width: 90,
                      height: 90,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://meow-type.serverku.my.id/foto/$foto',
                          fit: BoxFit.fill,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    title: Text(
                      jenis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(waktu),
                  ),
                ),
              ),
            );
          }).toList();
        });
      }
    } else {
      var jsonResponse = json.decode(response.body);
      var errorMessage = jsonResponse['message'];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Gagal Mengambil Riwayat'),
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
    return Scaffold(
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
                content: const Text('Apakah anda ingin keluar dari akun ini?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: const Text('Tidak'),
                  ),
                  TextButton(
                    onPressed: () async {
                      var headers = {'Cookie': sesi_cookie};

                      var url =
                          Uri.parse('https://meow-type.serverku.my.id/keluar');
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
          padding:
              const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
          child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: riwayat.isEmpty
                    ? [
                        const Center(
                          child: Text(
                            'Tidak Ada Riwayat',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ]
                    : riwayat,
              )),
        ),
      ),
    );
  }
}
