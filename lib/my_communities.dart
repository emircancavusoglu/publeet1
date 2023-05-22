import 'package:flutter/material.dart';
import 'package:publeet1/add_community.dart';

class MyCommunities extends StatefulWidget {
  final String toplulukIsmi;
  const MyCommunities({Key? key, required this.toplulukIsmi,}) : super(key: key);

  @override
  State<MyCommunities> createState() => _MyCommunitiesState();
}
class _MyCommunitiesState extends State<MyCommunities> {
  List<String> topluluklar = [];

  @override
  void initState() {
    super.initState();
    topluluklar = widget.toplulukIsmi.split(',');
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
      body: ListView.builder(
        itemCount: topluluklar.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              topluluklar[index],
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
