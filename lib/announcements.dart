import 'package:flutter/material.dart';

class Announc extends StatefulWidget {
  const Announc({Key? key}) : super(key: key);

  @override
  State<Announc> createState() => _AnnouncState();
}

class _AnnouncState extends State<Announc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (
      AppBar(title: const Text("Duyurular"),)
      ),
    );
  }
}
