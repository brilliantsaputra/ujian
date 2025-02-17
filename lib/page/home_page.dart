import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mini_demo/page/beli_page.dart';
import 'package:mini_demo/page/checkout_page.dart';
import 'package:mini_demo/page/create_menu_page.dart';
import 'package:mini_demo/page/history_page.dart';
import 'package:mini_demo/page/list_pengguna_page.dart';
import 'package:mini_demo/page/login_page.dart';
import 'package:mini_demo/page/pesanan_page.dart';
import 'package:mini_demo/page/profil_page.dart';
import 'package:mini_demo/page/splash_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email = GetStorage().read('email');

  @override
  void initState() {
    getDataMenu();
    super.initState();
  }

  void filterItems(String value) {
    log('Filtering items...');
    setState(() {
      if (value.isEmpty) {
        filter = data;
      } else {
        filter = data.where((item) => item['Nama'].contains(value)).toList();
      }
    });
  }

  List data = [];
  List id = [];

  void getDataMenu() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('menu').get();

      data = querySnapshot.docs.map((doc) => doc.data()).toList();
      id = querySnapshot.docs.map((doc) => doc.id).toList();

      setState(() {
        filter = data;
      });
      log(data.toString());
    } catch (e) {
      log("Error: $e");
    }
  }

  TextEditingController filterController = TextEditingController();

  GetStorage box = GetStorage();
  List filter = [];

  void deleteFirebase(String docId) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('menu').doc(docId).delete();
    getDataMenu();
    log('Delete Success');
  }

  void validasiDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ingin Menghapus Menu Ini?'),
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
              child: const Text('Iya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 209, 50),
        toolbarHeight: 60,
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
        title: const Text(
          'Food App',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
            icon:
                const Icon(Icons.account_circle, color: Colors.white, size: 36),
          ),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          children: [
            const SizedBox(height: 32),
            const ListTile(
              title: Text(
                'Food App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shop),
              title: const Text('Pesanan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PesananPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Keranjang'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryPage(
                      email: box.read('email'),
                    ),
                  ),
                );
              },
            ),
            Visibility(
              visible: email == 'admin@gmail.com',
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text('List Pengguna'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListPenggunaPage(),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                box.remove('email');
                Get.offAll(() => const SplashPage());
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  controller: filterController,
                  onChanged: filterItems,
                ),
              ),
              const Text(
                'Produk',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: filter.length,
                itemBuilder: (context, index) {
                  final idata = filter[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BeliPage(
                            namaBarang: idata['Nama'],
                            hargaBarang: idata['Harga'],
                            gambar: idata['Gambar'],
                            teks: idata['Teks'],
                            teks1: idata['Teks1'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    idata['Gambar'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  idata['Nama'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp ${idata['Harga']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (email == 'admin@gmail.com')
                                  InkWell(
                                    onTap: () {
                                      validasiDelete(id[index]);
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Hapus Menu Ini',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.red,
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: email == 'admin@gmail.com'
          ? FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateMenuPage(),
                  ),
                ).then((_) => getDataMenu());
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : const SizedBox(),
    );
  }
}