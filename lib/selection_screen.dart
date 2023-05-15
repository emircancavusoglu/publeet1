import 'package:flutter/material.dart';
import 'package:publeet1/find_community.dart';
import 'main.dart';
import 'communityWorld.dart';
import 'add_community.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Colors.black,),
                TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddCommunityForm()),
                    );
                  },
                  child: const Text(
                    "Topluluk Ekle",
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.find_in_page),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FindCommunity()));
                  },
                  child: const Text("Topluluk Bul",style: TextStyle(fontSize: 24, color: Colors.black),),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.public),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityScreen()));
                  },
                  child: const Text("Dünyadaki Topluluklar",style: TextStyle(fontSize: 24, color: Colors.black),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
