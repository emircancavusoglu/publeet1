import 'package:flutter/material.dart';

class CommunityDetails extends StatelessWidget {
  const CommunityDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Details"),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Text("community details"),
    );
  }
}
