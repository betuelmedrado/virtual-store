
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/cart_product.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/model/cart_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/orders_screen.dart';
import 'package:loja_virtual/tiles/cart_tile.dart';
import 'package:loja_virtual/widgets/cart_price.dart';
import 'package:loja_virtual/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/widgets/discount_cart.dart';



class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text('Meu Carrinho', style: TextStyle(
          color: Colors.white),),
        actions: [
          Container(
            padding:EdgeInsets.only(right: 13.0),
            child: ScopedModelDescendant<CartModel>(builder:(context, child, model){
              // para saber a quantidade de produtos ===
              int p_quant = model.products.length;

              return Text('${p_quant ?? 0} ${p_quant <= 1 ? 'Intem' : 'Items'}',
              style: TextStyle(fontSize: 19.0, color: Colors.white, fontWeight: FontWeight.bold));
            } ),

          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model){
          if(model.isLoading && UserModel.of(context).isLoggedIn()){
            return Center(child: CircularProgressIndicator());
          }else if(!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.only(right: 15.0, left: 15.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(Icons.remove_shopping_cart, size: 75.0, color: Theme
                        .of(context)
                        .primaryColor),
                    Text('Faça login para adicionar ao carrinho!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25.0)),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Theme
                              .of(context)
                              .primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Text('Entrar', style: TextStyle(
                            color: Colors.white, fontSize: 25.0)),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        },
                      ),
                    ),
                  ]
              ),
            );
          }else if(model.products.isEmpty || model.products.length <= 0){
              return Container(
                child: Center(child: Text('Seu carrinho esta vazio!', style: TextStyle(fontSize: 25.0)))
              );

          }else {
            return ListView(
              children: [
                Column(
                  children: model.products.map((product ){
                    return CartTile(product);

                  }).toList(),
                ),
                DiscountCart(),
                ShipCard(),
                CartPrice(() async{
                  String orderID = await model.finishiOrders();
                  if(orderID != null){
                    // pushReplacement substitui a tela por outra
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => OrdersScreen(orderID)));
                  }
                }),
              ],
            );
          }

        }),
    );
  }
}
