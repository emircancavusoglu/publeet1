import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthServices{
  final usersCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp({required String email, required String password})async{
    try{
      final UserCredential userCredential =  await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        _registerUser(email: email, password: password);
    }
    }on FirebaseAuthException catch(e){
      AlertDialog(content: Text(e.message.toString()),);
    }
}
  Future<void> _registerUser({required String email, required String password})async{
  await usersCollection.doc().set({
    "name": email,
    "password": password
  });
  }
}