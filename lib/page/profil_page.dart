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

  Future<Map<String, dynamic>> fetchUserProfile() async { 
    try {
      final email = box.read('email');
      if (email == null) {
        throw Exception('No email found in storage');
      }

      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('user') 
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('penguna tidak ditemukan');
      }

      return querySnapshot.docs[0].data();
    } catch (e) {
      throw Exception("kesalahan pengambilan data: $e");
    }
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
                        backgroundImage: AssetImage('assets/gura.jpg'), 
                      ),
                          const Divider(
                            thickness: 1.5,
                            color: Colors.grey,
                            height: 32,
                          ),
                          // const SizedBox(height: 16),
              
                          buildProfileInfoRow(Icons.account_circle,'Nama',userData['nama']?? '-'),
                          // const SizedBox(height: 16),
                          const Divider(
                            thickness: 1.5,
                            color: Colors.grey,
                            height: 32,
                          ),
                          buildProfileInfoRow(
                              Icons.email, 'Email', userData['email'] ?? '-'),
                          // const SizedBox(height: 16),
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

  Widget buildProfileInfoRow(IconData icon, String title, String info) {
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
            Text(
              info,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
