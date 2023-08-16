import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:publeet1/selection_screen.dart';

class AuthServices{
  final usersCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  
  Future<void> signUp({required String email, required String password})async{
    try{
      final UserCredential userCredential =  await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        registerUser(email: email, password: password);
    }
    }on FirebaseAuthException catch(e){
      Fluttertoast.showToast(msg: e.message!,toastLength: Toast.LENGTH_LONG);
    }
}
  Future<void> signIn(BuildContext context,{required String email, required String password}) async{
    final navigator = Navigator.of(context);
    try{
      final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        navigator.push(MaterialPageRoute(builder: (context) => SelectionScreen(),));
      }
    } on FirebaseAuthException catch(e){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(e.message!),
          );
        },
      );    }
}
  Future<void> registerUser({required String email, required String password})async{
  await usersCollection.doc().set({
    "email": email,
    "password": password
  });
  }

}