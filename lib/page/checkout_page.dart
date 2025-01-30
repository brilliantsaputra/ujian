import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mini_demo/page/bayar_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  GetStorage box = GetStorage();
  List data = [];
  List id = [];

  void getData() async {
    String email = box.read('email');
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('checkout')
          .where('Email', isEqualTo: email)
          .get();

      data = querySnapshot.docs.map((doc) => doc.data()).toList();
      id = querySnapshot.docs.map((doc) => doc.id).toList();

      setState(() {});
    } catch (e) {
      log("Error: $e");
    }
  }

  void deleteFirebase(String docId) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('checkout').doc(docId).delete();
    getData();
    log('Delete Success');
  }

  void validasiDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ingin Menghapus Pesanan Ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                deleteFirebase(docId);
                Navigator.pop(context);
              },
              child: const Text('IYA'),
            ),
          ],
        );
      },
    );
  }

  void tambahData(String docId) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('checkout').doc(docId).update({
        'Jumlah': FieldValue.increment(1),
      });
      getData();
      log("Jumlah berhasil ditambah.");
    } catch (e) {
      log("Gagal menambah jumlah: $e");
    }
  }

  void kurangData(String docId, int currentJumlah) async {
    final firestore = FirebaseFirestore.instance;
    try {
      if (currentJumlah > 1) {
        await firestore.collection('checkout').doc(docId).update({
          'Jumlah': FieldValue.increment(-1),
        });
      } else {
        deleteFirebase(docId);
      }
      getData();
      log("Jumlah berhasil dikurangi.");
    } catch (e) {
      log("Gagal mengurangi jumlah: $e");
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Checkout Page',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final idata = data[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BayarPage(
                              namaBarang: idata['Nama'],
                              jumlah: idata['Jumlah'],
                              harga: idata['Harga'],
                              index: index,
                              gambar: idata['Gambar'],
                              deskripsi: idata['Deskripsi'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 110,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    idata['Nama'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 60,
                                    width: 80,
                                    color: Colors.red,
                                    child: Image.asset(
                                      idata['Gambar'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 15), 
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Harga Rp.${idata['Harga'] * idata['Jumlah']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          onPressed: () => kurangData(id[index], idata['Jumlah']),
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                            size: 16,
                                          ),
                                        ),
                                        Text('${idata['Jumlah']}'),
                                        IconButton(
                                          onPressed: () => tambahData(id[index]),
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 20,
                                width: 50,
                                child: ElevatedButton(
                                  onPressed: () => validasiDelete(id[index]),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.delete, size: 10),
                                      Text('Hapus', style: TextStyle(fontSize: 8)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
