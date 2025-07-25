

import 'dart:collection'; //LinkedHashMap

import 'package:flutter/material.dart ';
import 'package:cloud_firestore/cloud_firestore.dart';


class OrderTile extends StatelessWidget {

  final String order_id;
  OrderTile(this.order_id, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 11.0,
      margin:EdgeInsets.symmetric(vertical: 4.0, horizontal: 11.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          // .snapshot é para actualizar os dado do app em tempo real
          stream: FirebaseFirestore.instance.collection('orders').doc(order_id).snapshots(), // .snapsshot
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else{

              int status = snapshot.data!['state'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Código do pedido: ${snapshot.data!.id}', style:TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height:4.0),
                  Text(_buildProductText(snapshot.data!)),
                  SizedBox(height:4.0),
                  Text('Status dos pedidos:', style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height:4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buidCircle('1', 'Preparação', status, 1),
                      Container(height: 1.0, width:40.0, color: Colors.grey[500]),
                      _buidCircle('2', 'Transporte', status, 2),
                      Container(height: 1.0, width:40.0, color: Colors.grey[500]),
                      _buidCircle('3', 'Entregue', status, 3),

                    ],
                  ),
                ],
              );
            }
          }
        ),
      ),
    );
  }

  String _buildProductText(DocumentSnapshot snapshot){
    String text = 'Descrição:\n';

    for(LinkedHashMap p in snapshot['product']){
      text += '   ${p['quantity']} x ${p['product']['title']} (R\$ ${p['product']['price'].toStringAsFixed(2)})\n';
    }
    text += 'Total: R\$ ${snapshot['productPrice']} ';
    return text;
  }


  Widget _buidCircle(String title, String subtitle, int status_db, int thisStatus){

    Color? background;
    Widget? childs;

    if(status_db <   thisStatus){
      background = Colors.grey;
      childs = Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,));
    }else if(status_db == thisStatus){
      background = Colors.blue;
      childs = Stack(
        alignment: Alignment.center,
        children: [
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),
        Text('${title}', style: TextStyle(color: Colors.white, fontWeight:FontWeight.bold),),
      ],);
    }else{
     background = Colors.green;
     childs = Icon(Icons.check, color: Colors.white);
    }

    return Column(
      children: [
        CircleAvatar(
          backgroundColor: background,
          child: childs,
        ),
        Text('${subtitle}'),
      ]
    );


  }

}
