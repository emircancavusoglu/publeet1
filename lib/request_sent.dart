import 'package:flutter/material.dart';


class RequestSent extends StatelessWidget {
  const RequestSent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 300,),
            const Text("İstek Gönderildi!",style: TextStyle(
              fontWeight: FontWeight.normal,fontSize: 28,color: Colors.green
            ),
            ),
            const Icon(Icons.check,size: 35,color: Colors.green,),
            const SizedBox(height: 100,),
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text("Yeni Topluluklara Katıl!",style: TextStyle(
              color: Colors.black,fontSize: 20,decoration: TextDecoration.underline
            ),))
          ],
        ),
      ),
    );
  }
}
