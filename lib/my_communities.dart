import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:publeet1/selection_screen.dart';

class MyCommunities extends StatefulWidget {
  const MyCommunities({Key? key}) : super(key: key);

  @override
  State<MyCommunities> createState() => _MyCommunitiesState();
}

class _MyCommunitiesState extends State<MyCommunities> {
  GetData data = GetData();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            SizedBox(
              width: 26,
            ),
            Text("Topluluklarım"),
            SizedBox(
              width: 4,
            ),
            Icon(Icons.group),
          ],
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: data.getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Text(
                  snapshot.data![index],
                  style: const TextStyle(
                    fontSize: 20,
                    decorationColor: Colors.deepPurple,
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
