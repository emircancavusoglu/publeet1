import 'main.dart';
import 'package:flutter/material.dart';

class FindCommunity extends StatefulWidget {
  const FindCommunity({Key? key}) : super(key: key);

  @override
  State<FindCommunity> createState() => _FindCommunityState();
}

class _FindCommunityState extends State<FindCommunity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: const [
            Icon(Icons.find_in_page),
            SizedBox(width: 10,),
            Text("Topluluk Bul"),
          ],
        ),
      ),
    );
  }
}
