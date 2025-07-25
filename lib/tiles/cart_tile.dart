
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/cart_product.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/model/cart_model.dart';


class CartTile extends StatelessWidget {

  final CartProduct cart_product;

  var context;

  CartTile(this.cart_product,{super.key, this.context});

  Widget _buildContent(){
    // Para atualizar a tela sempre que abrir o cardTile
    CartModel.of(context).updatePrice();

    return Row(
      children: [
        Container(
          width: 120.0,
          padding: EdgeInsets.all(8.0),
          child: Image.network(cart_product.product_data?.images?[0],
          fit:BoxFit.cover),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${cart_product.product_data?.title}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19.0)),
                Text('Tamanho: ${cart_product.size}', style:TextStyle(fontWeight: FontWeight.w400)),
                Text('R\$ ${cart_product.product_data?.price?.toStringAsFixed(2)} ', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:16.0,
                  color: Theme.of(this.context).primaryColor,
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 20.0,
                  children: [
                    IconButton(
                      onPressed: cart_product.quantity == 1 ? null : (){CartModel.of(context).decrement_product(cart_product);},
                      icon: Icon(Icons.remove, color: cart_product.quantity! > 1 ? Theme.of(context).primaryColor : Colors.grey),),
                    Text('${cart_product.quantity}'),
                    IconButton(
                      onPressed: (){CartModel.of(context).increment_product(cart_product);},
                      icon: Icon(Icons.add, color: Theme.of(context).primaryColor,),),
                    TextButton(
                      child: Text('Remove', style: TextStyle(color: Colors.grey[500]),),
                      onPressed: (){CartModel.of(context).removeCartItem(cart_product);},
                    ),
                  ],
                ),
              ],
            ),
          )),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Card(
      child: cart_product.product_data == null ?
      FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('products').doc(cart_product.category).collection('items').doc(cart_product.p_id).get(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            // Salvando os produto para que não presize buscar novamente no banco de dados em quanto não fechar o app
            cart_product.product_data = ProductsData.fromDocuments(snapshot.data!);
            return _buildContent();
          }else{
            return  Container(child: CircularProgressIndicator(), alignment: Alignment.center,);
          }

        }
      ) : _buildContent(),
    );
  }
}
