import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateMenuPage extends StatefulWidget {
  const CreateMenuPage({
    super.key,
  });

  @override
  State<CreateMenuPage> createState() => _CreateMenuPageState();
}

class _CreateMenuPageState extends State<CreateMenuPage> {
  TextEditingController namaCtrl = TextEditingController(),
      hargaCtrl = TextEditingController(),
      des1 = TextEditingController(),
      des2 = TextEditingController();
  String gambarDipilih = '';

  List gambar = [
    'assets/bakso.jpg',
    'assets/gura.jpg',
    // 'assets/logo.png',
    'assets/soto1.jpg',
    'assets/nasi_goreng1.png',
    'assets/nasi.jpg',
    'assets/ayam.jpeg',
    'assets/mie.jpeg',
  ];

  void createData() async {
    CollectionReference pesanan = FirebaseFirestore.instance.collection('menu');
    await pesanan.add({
      'Nama': namaCtrl.text,
      'Harga': int.tryParse(hargaCtrl.text) ?? 0,
      'Gambar': gambarDipilih,
      'Teks': des1.text,
      'Teks1': des2.text,
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void getGambar() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: SizedBox(
          height: Get.height,
          width: 100,
          child: Column(
            children: [
              Text('Pilih Gambar'),
              Expanded(
                child: ListView.builder(
                  itemCount: gambar.length,
                  itemBuilder: (context, index) {
                    String idata = gambar[index];
                    return InkWell(
                      onTap: () {
                        gambarDipilih = idata;
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          idata,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget input({
    required TextEditingController controller,
    bool textNumber = false,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: textNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      onTapOutside: (_) => FocusManager.instance.primaryFocus!.unfocus(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Menu Makanan'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              input(
                controller: namaCtrl,
                hintText: 'Nama',
              ),
              input(
                controller: hargaCtrl,
                hintText: 'Harga',
                textNumber: true,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      const Text('Tambah Gambar'),
                      IconButton(
                        onPressed: () {
                          getGambar();
                        },
                        icon: const Icon(Icons.add),
                      ),
                      Visibility(
                        visible: gambarDipilih.isNotEmpty,
                        child: Text(
                          'Gambar Disimpan',
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: gambarDipilih.isNotEmpty,
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset(gambarDipilih),
                    ),
                  ),
                ],
              ),
              input(
                controller: des1,
                hintText: 'Deskripsi 1',
              ),
              input(
                controller: des2,
                hintText: 'Deskripsi 2',
              ),
              ElevatedButton(
                onPressed: () {
                  createData();
                },
                child: Text(
                  'Simpan',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
