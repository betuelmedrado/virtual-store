
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';

import '../tiles/order_tile.dart';


class OrderTabe extends StatelessWidget {
  const OrderTabe({super.key});

  @override
  Widget build(BuildContext context) {
    if(UserModel.of(context).isLoggedIn()){

      String uid = UserModel.of(context).firebase_user!.uid;
      
      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).collection('orders').get(),
        builder:(context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((doc) => OrderTile(doc.id)).toList().reversed.toList(),
            );
          }
        }
      );

    }else{
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(size:100.0, Icons.view_list, color: Theme.of(context).primaryColor),
            Text('Faça login para acompanhar seus pedidos!', textAlign: TextAlign.center, style: TextStyle(fontWeight:FontWeight.bold, fontSize: 22.0)),
            Container(
              width: 1000.0,
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)) ,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text('Entrar', style:TextStyle(fontSize: 25.0,color: Colors.white)),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));

                },
              ),
            ),
          ],
        ),
      );

    }

    }
  }
