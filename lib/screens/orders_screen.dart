
import 'package:flutter/material.dart';


class OrdersScreen extends StatelessWidget {

  String order_id;

  OrdersScreen(this.order_id,{super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text('Pedidido Realizado', style:TextStyle(color: Colors.white)),
      ),
      body:Container(
        alignment:Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Icon(size:35.0, Icons.check, color: Theme.of(context).primaryColor),
            Text('Pedido Ralizado com sucesso!', style: TextStyle(fontWeight:FontWeight.bold, fontSize: 22.0)),
            Text('Código do pedido: ${order_id}'),

          ]
        ),
      ),

    );
  }
}
