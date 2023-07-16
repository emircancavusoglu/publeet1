import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publeet1/login_screen.dart';
import 'community_details.dart';
import 'initialize/app_initialize.dart';
import 'location/sign_location.dart';


Future<void> main() async {
  await ApplicationInitialize.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationProvider(),
      child: MaterialApp(
        title: 'Publeet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginScreen(),
        routes: {
          '/communityDetails': (context) => const CommunityDetails(communityName: '',), // CommunityDetails route'ını tanımlayın
        },
      ),
    );
  }
}
