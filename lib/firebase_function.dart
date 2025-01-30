import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

Future<void> addUser() async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  
  try {
    await users.add({
      'name': 'Febrian',
      'email': 'abirin@example.com',
      'age': 16,
    });

    log("User added successfully!");
  } catch (e) {
    log("Error adding user: $e");
  }
}
