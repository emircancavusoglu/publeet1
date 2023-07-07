import 'package:flutter/material.dart';
import 'package:publeet1/community_details.dart';
import 'package:publeet1/request_sent.dart';

class CommunityList extends StatelessWidget {
  final String? address;

  const CommunityList({Key? key, this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Topluluk Listesi"),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const CommunityDetails()));
            },
            child: ListTile(
              title: const Row(
                children: [
                  Text("Satranç Topluluğu"),
                  SizedBox(width: 8,),
                  Text(" 5 km uzaklıkta",style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),
                  SizedBox(width: 3,),
                  Icon(Icons.stars_outlined)
                ],
              ),
              subtitle: Text(address ?? ""),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const CommunityDetails()));
            },
            child: ListTile(
              title: const Row(
                children: [
                  Text(" Ybs Topluluğu"),
                  SizedBox(width: 8,),
                  Text(" 8 km uzaklıkta",style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),
                  SizedBox(width: 3,),
                  Icon(Icons.stars_outlined),
                ],
              ),
              subtitle: Text(address ?? ""),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const CommunityDetails()));
            },
            child: ListTile(
              title: const Row(
                children: [
                  Text("Gezi Topluluğu"),
                  SizedBox(width: 8,),
                  Text(" 15 km uzaklıkta",style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),
                  SizedBox(width: 3,),
                  Icon(Icons.stars_outlined)
                ],
              ),
              subtitle: Text(address ?? ""),
            ),
          ),
        ],
      ),
    );
  }
}
