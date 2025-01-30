import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  GetStorage box = GetStorage();
  List data = [];
  List id = [];

  @override
  void initState() {
    // data = box.read('pesanan') ?? [];
    readDataPesanan();
    super.initState();
  }

  void readDataPesanan() async {
    String email = box.read('email');
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('pesanan')
          .where('email_pemesan', isEqualTo: email)
          .get();

      data = querySnapshot.docs.map((doc) => doc.data()).toList();
      id = querySnapshot.docs.map((doc) => doc.id).toList();

      log(data.toString());

      setState(() {});
    } catch (e) {
      log('Error: $e');
    }
  }

  void pesananDone(
    final Map data,
    final int index,
  ) async {
    CollectionReference pesanan =
        FirebaseFirestore.instance.collection('history');
    await pesanan.add(data);

    deletePesanan(id[index]);
  }

  void deletePesanan(String docId) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('pesanan').doc(docId).delete();
    readDataPesanan();
    terimahKasih();
    log('Delete Success');
  }

  void pesananDiterima(
    Map data,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Apakah Pesanan Sudah Diterima?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Belum'),
          ),
          TextButton(
            onPressed: () {
              // List update = data;
              // update.removeAt(index);
              // box.write('pesanan', update);
              // setState(() {
              //   data = box.read('pesanan') ?? [];
              // });
              // Navigator.pop(context);
              // terimahKasih();
              Navigator.pop(context);
              pesananDone(
                data,
                index,
              );
            },
            child: const Text('Sudah'),
          ),
        ],
      ),
    );
  }

  void terimahKasih() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Terimah Kasih Telah Memesan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
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
          'Pesanan Saya',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pesanan Saya',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final idata = data[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            child: Text(
                              'Pesanan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: Image.asset(
                                          idata['Gambar'],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              idata['Nama'],
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              idata['Deskripsi'],
                                              style: const TextStyle(
                                                fontSize: 9,
                                              ),
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Rp ${idata['Total']}',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Jumlah ${idata['Jumlah']}x',
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        height: 25,
                                        width: 100,
                                        child: ElevatedButton(
                                          onPressed: () => pesananDiterima(
                                            idata,
                                            index,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding: const EdgeInsets.all(0),
                                          ),
                                          child: const Text(
                                            'Pesanan Diterima',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
