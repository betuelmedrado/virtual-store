

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../tiles/place_tile.dart';

class PlaceTabe extends StatelessWidget {
  const PlaceTabe({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('places').get(),
      builder: (context, snapshoot){

        if(!snapshoot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else{
          return ListView(
            children: snapshoot.data!.docs.map((doc) => PlaceTile(doc)).toList(),
          );
        }

      });
  }
}
