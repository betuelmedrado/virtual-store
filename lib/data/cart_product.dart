

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/data/products_data.dart';

class CartProduct{

  String? c_id;
  String? category;
  String? p_id;
  int? quantity;
  String? size;

  ProductsData? product_data;

  // Construtor vazio
  CartProduct();

  CartProduct.fromDocuments(DocumentSnapshot document){
    c_id = document.id;
    category = document['category'];
    p_id = document['p_id'];
    quantity = document['quantity'];
    size = document['size'];
  }

  // Para salvar no banco de dados #############
  Map<String,dynamic> saveMap(){
    return {
      "category": category,
      "p_id" : p_id,
      "quantity": quantity,
      "size" : size,
      "product": product_data?.toResumedMap(),
    };

  }


}