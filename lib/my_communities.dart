import 'package:flutter/material.dart';
import 'package:publeet1/add_community.dart';

class MyCommunities extends StatefulWidget {
  const MyCommunities({Key? key,}) : super(key: key);

  @override
  State<MyCommunities> createState() => _MyCommunitiesState();
}

class _MyCommunitiesState extends State<MyCommunities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back),onPressed: (){
          Navigator.pop(context);
        },),
        title: Row(
          children: const [
            SizedBox(width: 26,),
            Text("Topluluklarım"),
            SizedBox(width: 4,),
            Icon(Icons.group)
          ],
        ),
      ),
      body: const Text(""),
    );
  }
}
