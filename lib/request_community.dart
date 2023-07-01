import 'package:flutter/material.dart';
import 'package:publeet1/selection_screen.dart';

class RequestCommunity extends StatelessWidget {
  const RequestCommunity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Card(
              color: Colors.white70,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: const ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.white, size: 48),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const ListTile(
                      title: Text('Topluluk oluşturma isteğiniz gönderilmiştir. Topluluğunuz onaylandığında topluluklarım sayfasından görüntüleyebilirsiniz.', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SelectionScreen(),));
                    },
                    child: const Text("Anasayfaya Dön"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
