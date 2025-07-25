

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsData{

  String? category;
  String? id;
  String? title;
  String? description;
  double? price;
  List? images;
  List? sizes;

  ProductsData.fromDocuments(DocumentSnapshot snapshot){
    id = snapshot.id;
    title = snapshot.get('title');
    description = snapshot.get('description');
    price = snapshot.get('price');
    images = snapshot.get('images');
    sizes = snapshot.get('sizes');
  }

  Map<String, dynamic> toResumedMap(){
    return {
      "title":title,
      "description":description,
      "price":price,
    };

  }


}