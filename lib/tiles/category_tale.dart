

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/screens/category_screen.dart';

class CategoryTale extends StatelessWidget {

  final DocumentSnapshot snapshot;

  const CategoryTale(this.snapshot, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.get('icon')),
      ),
      title: Text('${snapshot.get('title')}'),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder:(context) => CategoryScreen(snapshot)));
      },// A cetinha da direita
    ) ;
  }
}
