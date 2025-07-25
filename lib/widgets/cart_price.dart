
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {

  final Function buy;

  CartPrice(this.buy,{super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:Border(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model){

            double price = model.getProductPrice();
            double dicount = model.getDiscount();
            double ship = model.getShipPrice();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumo do pedido', style: TextStyle(fontWeight: FontWeight.w500),),
                SizedBox(height: 12.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal'),
                    Text('R\$ ${price.toStringAsFixed(2)}'),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Desconto'),
                    Text('R\$ -${dicount.toStringAsFixed(2)}'),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Entrega'),
                    Text('R\$ ${ship.toStringAsFixed(2)}'),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('R\$ ${(price + ship - dicount).toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18.0)),
                  ],
                ),
                SizedBox(height: 12.0),
                Container(
                  width: 1000.0,
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
                      ),
                      onPressed: (){
                        // model.finishiOrders();
                        this.buy();
                      },
                      child: Text('Finalizar pedido',style: TextStyle(color: Colors.white, fontSize: 17.0),)),
                )

              ],
            );
          }
        ),
    ));
  }
}
