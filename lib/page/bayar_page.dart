import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class BayarPage extends StatefulWidget {
  final String namaBarang;
  final int jumlah;
  final int harga;
  final int? index;
  final String gambar;
  final String deskripsi;
  const BayarPage({
    super.key,
    required this.namaBarang,
    required this.jumlah,
    required this.harga,
    this.index,
    required this.gambar,
    required this.deskripsi,
  });

  @override
  State<BayarPage> createState() => _BayarPageState();
}

class _BayarPageState extends State<BayarPage> {
  GetStorage box = GetStorage();
  List pesanan = [];

  void createPesananSaya() async {
    CollectionReference pesanan = FirebaseFirestore.instance.collection('pesanan');
    await pesanan.add({
      'email_pemesan': box.read('email') ?? 'Email Tidak Diketahui',
      'Nama': widget.namaBarang,
      'Jumlah': widget.jumlah,
      'Harga': widget.harga,
      'Total': widget.jumlah * widget.harga,
      'Gambar': widget.gambar,
      'Deskripsi': widget.deskripsi,
    });
    selesai();
  }

  // void bayar() {
  //   pesanan = box.read('pesanan') ?? [];
  //   Map dataPesanan = {
  //     'Nama': widget.namaBarang,
  //     'Jumlah': widget.jumlah,
  //     'Harga': widget.harga,
  //     'Total': widget.jumlah * widget.harga,
  //     'Gambar': widget.gambar,
  //     'Deskripsi': widget.deskripsi,
  //   };
  //   pesanan.add(dataPesanan);
  //   if (widget.index != null) {
  //     deleteKeranjang(widget.index!);
  //   }
  //   box.write('pesanan', pesanan);
  //   selesai();
  // }

  void selesai() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Pesanan Berhasil Dibuat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void deleteKeranjang(int index) {
    List data = box.read('data');
    data.removeAt(index);
    box.write('data', data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 13, 162, 60),
                Color.fromARGB(255, 78, 230, 116)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Bayar Barang',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Detail Pembelian',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama Barang',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.namaBarang,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Harga Barang',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rp.${widget.harga}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Jumlah Pembelian',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.jumlah}x',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'Total Bayar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rp.${widget.jumlah * widget.harga}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () => createPesananSaya(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Beli Sekarang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
