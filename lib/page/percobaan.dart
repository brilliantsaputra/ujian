// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class FirestoreService {
//   final CollectionReference percobaanCollection =
//       FirebaseFirestore.instance.collection('percobaan');

//   Future<void> createData(String nama, int nik) async {
//     await percobaanCollection.add({'nama': nama, 'nik': nik});
//   }

//   Stream<QuerySnapshot> readData() {
//     return percobaanCollection.snapshots();
//   }

//   Future<void> updateData(String docId, String nama, int nik) async {
//     await percobaanCollection.doc(docId).update({'nama': nama, 'nik': nik});
//   }

//   Future<void> deleteData(String docId) async {
//     await percobaanCollection.doc(docId).delete();
//   }
// }

// class CrudScreen extends StatelessWidget {
//   final FirestoreService firestoreService = FirestoreService();
//   final TextEditingController namaController = TextEditingController();
//   final TextEditingController nikController = TextEditingController();

//   CrudScreen({super.key});

//   void showUpdateDialog(BuildContext context, String docId, String currentNama, int currentNik) {
//     TextEditingController updateNamaController = TextEditingController(text: currentNama);
//     TextEditingController updateNikController = TextEditingController(text: currentNik.toString());

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Update Data"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: updateNamaController,
//                 decoration: const InputDecoration(labelText: "Nama"),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: updateNikController,
//                 decoration: const InputDecoration(labelText: "NIK"),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Batal"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 firestoreService.updateData(
//                   docId,
//                   updateNamaController.text,
//                   int.parse(updateNikController.text),
//                 );
//                 Navigator.pop(context);
//               },
//               child: const Text("Update"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//        AppBar(title: const Text("percobaan")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
            
//             TextField(
//               controller: namaController,
//               decoration: const InputDecoration(
//                 labelText: "Nama",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),

//             // Input untuk NIK
//             TextField(
//               controller: nikController,
//               decoration: const InputDecoration(
//                 labelText: "NIK",
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 10),

            
//             ElevatedButton(
//               onPressed: () {
//                 if (namaController.text.isNotEmpty &&
//                     nikController.text.isNotEmpty) {
//                   firestoreService.createData(
//                     namaController.text,
//                     int.parse(nikController.text),
//                   );

//                   namaController.clear();
//                   nikController.clear();
//                 }
//               },
//               child: const Text("Tambah Data"),
//             ),
//             const SizedBox(height: 10),

            
//             Expanded(
//               child: StreamBuilder(
//                 stream: firestoreService.readData(),
//                 builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   return ListView(
//                     children: snapshot.data!.docs.map((doc) {
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 5),
//                         child: ListTile(
//                           title: Text("Nama: ${doc['nama']}"),
//                           subtitle: Text("NIK: ${doc['nik']}"),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
                              
//                               IconButton(
//                                 icon: const Icon(Icons.edit, color: Colors.blue),
//                                 onPressed: () {
//                                   showUpdateDialog(
//                                     context,
//                                     doc.id,
//                                     doc['nama'],
//                                     doc['nik'],
//                                   );
//                                 },
//                               ),

                              
//                               IconButton(
//                                 icon: const Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () {
//                                   firestoreService.deleteData(doc.id);
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
