import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ApplicationInitialize{
  static Future<void> init() async{ //init metodu, Flutter uygulamasının başlatılması ve
    // Firebase hizmetlerinin başlatılması için kullanılır. Bu metot, uygulamanın başlangıcında çağrılır ve gerekli başlangıç ayarlarını gerçekleştirir.
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

}
