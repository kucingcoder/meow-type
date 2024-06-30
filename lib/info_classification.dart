import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Info_Classification extends StatefulWidget {
  final String foto;
  final String jenis;
  final int umur_min;
  final int umur_max;
  final int harga_min;
  final int harga_max;
  final int berat_min;
  final int berat_max;
  final int panjang_min;
  final int panjang_max;
  final String deskripsi_teks;

  const Info_Classification({
    super.key,
    required this.foto,
    required this.jenis,
    required this.umur_min,
    required this.umur_max,
    required this.harga_min,
    required this.harga_max,
    required this.berat_min,
    required this.berat_max,
    required this.panjang_min,
    required this.panjang_max,
    required this.deskripsi_teks,
  });

  @override
  State<Info_Classification> createState() => _Info_ClassificationState();
}

class _Info_ClassificationState extends State<Info_Classification> {
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
          'Kucing ${widget.jenis}',
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
                          'https://meow-type.serverku.my.id/foto/${widget.foto}',
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
                        Text('${widget.berat_min} Kg - ${widget.berat_max} Kg')
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
                        Text(
                            '${widget.panjang_min} Cm - ${widget.panjang_max} Cm')
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
                        Text(
                            '${widget.umur_min} Tahun - ${widget.umur_max} Tahun')
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
                            '${formatRupiah(widget.harga_min)} - ${formatRupiah(widget.harga_max)}')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 15, right: 15, bottom: 15),
                    child: Text(
                      widget.deskripsi_teks,
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
