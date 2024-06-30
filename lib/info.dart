import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'session.dart';

class Info extends StatefulWidget {
  final String gambar;
  final String kucing;

  const Info({
    super.key,
    required this.gambar,
    required this.kucing,
  });

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  int umur_min = 0;
  int umur_max = 0;
  int harga_min = 0;
  int harga_max = 0;
  int berat_min = 0;
  int berat_max = 0;
  int panjang_min = 0;
  int panjang_max = 0;
  String deskripsi_teks = 'Lorem ipsum';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var request = http.MultipartRequest(
      'GET',
      Uri.parse(
          'https://meow-type.serverku.my.id/info-kucing?jenis=${widget.kucing}'),
    );

    request.headers['Cookie'] = sesi_cookie;

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var data = jsonResponse['data'];

      setState(() {
        umur_min = data['umur_min'];
        umur_max = data['umur_max'];
        harga_min = data['harga_min'];
        harga_max = data['harga_max'];
        berat_min = data['berat_min'];
        berat_max = data['berat_max'];
        panjang_min = data['panjang_min'];
        panjang_max = data['panjang_max'];
        deskripsi_teks = data['deskripsi_teks'];
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

  String formatRupiah(int amount) {
    var format =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kucing ${widget.kucing}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 350,
                        child: Image.network(
                          widget.gambar,
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
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 15, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Berat : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('$berat_min Kg - $berat_max Kg')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Panjang : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('$panjang_min Cm - $panjang_max Cm')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Umur : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('$umur_min Tahun - $umur_max Tahun')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Harga : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            '${formatRupiah(harga_min)} - ${formatRupiah(harga_max)}')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 15, right: 15, bottom: 15),
                    child: Text(
                      deskripsi_teks,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
