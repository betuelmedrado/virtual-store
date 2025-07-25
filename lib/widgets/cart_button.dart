

import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/cart_screen.dart';


class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.shopping_cart,size: 40.0,color: Colors.white,),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen()));

      });
  }
}
