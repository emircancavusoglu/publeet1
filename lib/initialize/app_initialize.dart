import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


@immutable
class ApplicationInitialize{
  const ApplicationInitialize._();
  static Future<void> init() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
}
