
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/cart_model.dart';


class DiscountCart extends StatelessWidget {
  const DiscountCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text('Cupom de Desconto', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),),
        leading:Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digete seu cumpo',
              ),
              // initialValue: CartModel.of(context).discount_percentage.toString() ?? "",
              // ###########  onFieldSubmitted Para usar o enter #############
              onFieldSubmitted: (text){
                FirebaseFirestore.instance.collection('coupons').doc(text).get().then((docSnap){
                  if(docSnap.data() != null ){
                    // Giving dicount  coupon
                    CartModel.of(context).setCoupon(text, docSnap.data()!['percent'] );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        content: Text('Desconte de ${docSnap.data()?['percent']}% aplicado',))
                    );
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cupom não valido!'), backgroundColor: Colors.red,),
                    );

                  }

                });
              },
            ),

          )
        ],


      ),
    );
  }
}
