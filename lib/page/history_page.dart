import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final String email;
  const HistoryPage({
    super.key,
    required this.email,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List data = [];
  List id = [];
  int totalPendapatan = 0;

  @override
  void initState() {
    getData();
    getTotalPendapatan();
    super.initState();
  }

  void getData() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('history')
          .where('email_pemesan', isEqualTo: widget.email)
          .get();

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
      if (widget.email == 'admin@gmail.com') {
        final firestore = FirebaseFirestore.instance;
        final querySnapshot = await firestore
            .collection('history')
            .where('email_pemesan', isEqualTo: widget.email)
            .get();

        totalPendapatan = querySnapshot.docs.fold(
          0,
          // ignore: avoid_types_as_parameter_names
          (sum, doc) => sum + (doc.data()['Total'] as int),
        );

        setState(() {});
        log('Total Pendapatan for ${widget.email}: $totalPendapatan');
      } else {
        log('Access Denied: ${widget.email} is not authorized to view total pendapatan.');
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History Pesanan"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // if (widget.email == 'admin@gmail.com')
            //   Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Text(
            //       'Total Pendapatan: Rp $totalPendapatan',
            //       style: const TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final idata = data[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              'Pesanan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(height: 1),
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
