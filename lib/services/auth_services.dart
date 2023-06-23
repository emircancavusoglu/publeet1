import 'package:cloud_firestore/cloud_firestore.dart';


class AuthServices{
  final usersCollection = FirebaseFirestore.instance.collection("users");
  Future<void> registerUser({required String name, required String password})async{
  await usersCollection.doc().set({
    "name": name,
    "password": password
  });
  }
}