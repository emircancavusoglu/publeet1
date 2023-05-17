import 'package:flutter/material.dart';
import 'package:publeet1/find_community.dart';
import 'login_screen.dart';
import 'communityWorld.dart';
import 'add_community.dart';

class SelectionScreen extends StatelessWidget {
  final String userName;
  const SelectionScreen({Key? key, required this.userName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hoşgeldin $userName"),
      ),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  FindCommunity()));
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  const CommunityScreen()));
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
