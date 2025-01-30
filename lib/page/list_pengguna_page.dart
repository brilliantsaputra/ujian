import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_demo/page/history_page.dart';

class ListPenggunaPage extends StatefulWidget {
  const ListPenggunaPage({super.key});

  @override
  State<ListPenggunaPage> createState() => _ListPenggunaPageState();
}

class _ListPenggunaPageState extends State<ListPenggunaPage> {
  List data = [];
  List id = [];
  int totalPendapatan = 0;
  bool isAdmin = true; // Contoh peran admin, sesuaikan logikanya dengan autentikasi Anda.

  @override
  void initState() {
    getDataUser();
    getTotalPendapatan();
    super.initState();
  }

  void getDataUser() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('user').get();

      data = querySnapshot.docs.map((doc) => doc.data()).toList();
      id = querySnapshot.docs.map((doc) => doc.id).toList();

      setState(() {});
      log(data.toString());
    } catch (e) {
      log("Error: $e");
    }
  }

  void getTotalPendapatan() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('history').get();

      totalPendapatan = querySnapshot.docs.fold(
        0,
        (sum, doc) => sum + (doc.data()['Total'] as int),
      );

      setState(() {});
      log('Total Pendapatan: $totalPendapatan');
    } catch (e) {
      log("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Pengguna'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total Pendapatan: Rp $totalPendapatan',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (c, index) {
                  var idata = data[index];
                  return ListTile(
                    title: Text(idata['nama']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryPage(
                            email: idata['email'],
                          ),
                        ),
                      );
                    },
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
