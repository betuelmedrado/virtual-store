

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/tiles/category_tale.dart';


class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('products').get(),
      builder: (context, snapshots){
        if(!snapshots.hasData){
          return Center(child: CircularProgressIndicator(color: Colors.cyan[700],));
        }
        else{
          //  study more
          var divider_tiles = ListTile.divideTiles(
            color: Colors.grey[500],
            tiles: snapshots.data!.docs.map((doc){
              return CategoryTale(doc);
            }).toList(),
          ).toList();

          return ListView(
            children: divider_tiles,
          );
        }

      });
  }
}
