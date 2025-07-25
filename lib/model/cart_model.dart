

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/cart_product.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel? user;

  List<CartProduct> products = [];

  String? coupon_code;
  int discount_percentage = 0;

  bool isLoading = false;

  CartModel(this.user){
    if(user!.isLoggedIn()){
      _loadCartIntems();
    }

  }

  // Para ter acesso sem presizar do ScoppedModel
  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);


  void addCartItem(CartProduct cart_product){
    products.add(cart_product);

    // Adicionando um produto no carrinho
    FirebaseFirestore.instance.collection('users').doc(user?.firebase_user?.uid).collection('cart').add(cart_product.saveMap()).then((doc){
      cart_product.c_id = doc.id;
    });

    notifyListeners();

  }

  void removeCartItem(CartProduct cart_product){
   FirebaseFirestore.instance.collection('users').doc(user?.firebase_user?.uid).collection('cart').doc(cart_product.c_id).delete();
   products.remove(cart_product);
    notifyListeners();
  }

  void decrement_product(CartProduct cart_product){
    int quantity = cart_product.quantity!.toInt();
    quantity--;
    cart_product.quantity = quantity;

    FirebaseFirestore.instance.collection('users').doc(user?.firebase_user?.uid).collection('cart').doc(cart_product.c_id).update(cart_product.saveMap());
    notifyListeners();

  }

  void increment_product(CartProduct cart_product){
    int quantity = cart_product.quantity!.toInt();
    quantity++;
    cart_product.quantity = quantity;

    FirebaseFirestore.instance.collection('users').doc(user?.firebase_user?.uid).collection('cart').doc(cart_product.c_id).update(cart_product.saveMap());
    notifyListeners();
  }

  void updatePrice(){
    notifyListeners();
  }

  void setCoupon(String coupon_code, int discount_percentage){
    this.coupon_code = coupon_code;
    this.discount_percentage = discount_percentage;
  }

  double getProductPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.product_data != null){
        price += c.quantity! * c.product_data!.price!;
      }
    }
    return price;
  }

  double getDiscount(){
    double discount = 0;

    return getProductPrice() * discount_percentage / 100;
  }

  double getShipPrice(){
    return 9.99;
  }

  Future<String> finishiOrders() async{

    isLoading = true;
    notifyListeners();

    double productPrice = getProductPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    // Saving orders in the orders database
    // DocumentReference para obter a referença do pedido para ter o id do pedido
    DocumentReference reference_orders = await FirebaseFirestore.instance.collection('orders').add({
      'clientId' : user!.firebase_user!.uid ,
      'product' : products.map((CartProduct) => CartProduct.saveMap()).toList(),
      'shipPrice' : shipPrice,
      'productPrice' : productPrice,
      'discount' : discount,
      'totalPrice' : productPrice + shipPrice - discount,
      'state' : 1,
    });

    // Saving the order id in the user
    FirebaseFirestore.instance.collection('users').doc(user?.firebase_user?.uid).collection('orders').doc(reference_orders.id).set(
      {
        'OrdersID' : reference_orders.id,
      }
    );

    // Getthing the products from the cart to be deleted
    QuerySnapshot query = await FirebaseFirestore.instance.collection('users').doc(user?.firebase_user?.uid).collection('cart').get();

    // Deleting products from the cart
    for(DocumentSnapshot doc in query.docs){
      doc.reference.delete();
    }

    products.clear();
    coupon_code = null;
    discount = 0;

    isLoading = false;
    notifyListeners();

    return reference_orders.id;
  }


  void _loadCartIntems() async{

    QuerySnapshot query = await FirebaseFirestore.instance.collection('users').doc(user?.firebase_user?.uid).collection('cart').get();
    products = query.docs.map((doc) => CartProduct.fromDocuments(doc)).toList();
    notifyListeners();
  }

}