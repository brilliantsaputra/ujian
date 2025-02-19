import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GetStorage box = GetStorage();
  final TextEditingController _nameController = TextEditingController();

  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final email = box.read('email');
      if (email == null) {
        throw Exception('No email found in storage');
      }

      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('user').where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Pengguna tidak ditemukan');
      }

      return querySnapshot.docs[0].data();
    } catch (e) {
      throw Exception("Kesalahan pengambilan data: $e");
    }
  }

  Future<void> updateUserName(String newName) async {
    try {
      final email = box.read('email');
      if (email == null) return;

      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('user').where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;
        await firestore.collection('user').doc(docId).update({'nama': newName});
        setState(() {});
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui nama: $e')),
      );
    }
  }

  void _showEditNameDialog(String currentName) {
    _nameController.text = currentName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Nama'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Masukkan nama baru'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                updateUserName(_nameController.text);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
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
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 13, 162, 60),
                Color.fromARGB(255, 78, 230, 116),
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
          'Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Data tidak ada'),
                  );
                }

                final userData = snapshot.data!;
                final userName = userData['nama'] ?? '-';

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 32.0, horizontal: 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/profile.png'),
                          ),
                          const SizedBox(height: 16),
                          // const Text(
                          //   'User Profile',
                          //   style: TextStyle(
                          //     fontSize: 24,
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.black87,
                          //   ),
                          // ),
                          const Divider(
                            thickness: 1.5,
                            color: Colors.grey,
                            height: 32,
                          ),
                          GestureDetector(
                            onTap: () => _showEditNameDialog(userName),
                            child: buildProfileInfoRow(
                                Icons.account_circle, 'Nama', userName, true),
                          ),
                          const Divider(
                            thickness: 1.5,
                            color: Colors.grey,
                            height: 32,
                          ),
                          buildProfileInfoRow(
                              Icons.email, 'Email', userData['email'] ?? '-'),
                          const Divider(
                            thickness: 1.5,
                            color: Colors.grey,
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileInfoRow(IconData icon, String title, String info, [bool editable = false]) {
    return Row(
      children: [
        Icon(icon, color: Colors.orangeAccent, size: 28),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  info,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                if (editable)
                  GestureDetector(
                    onTap: () => _showEditNameDialog(info),
                    child: const Icon(Icons.edit, size: 20, color: Colors.blueAccent),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}