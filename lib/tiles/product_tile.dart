
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/screens/product_screen.dart';


class ProductTile extends StatelessWidget {

  final String type;
  final ProductsData product;

  ProductTile(this.type, this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductScreen(product)));

      },
      child:Card(
        child: this.type == 'grid' ?
            Column(
              children: [
                AspectRatio(
                  aspectRatio:0.8,
                  child: Image.network(
                    fit: BoxFit.cover,
                    product.images![0]),
                  ),
                 Expanded(
                   child: Container(
                      padding:EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${product.title}', style: TextStyle(fontWeight: FontWeight.w700,),),
                          Text('R\$ ${product.price.toString()}', style: TextStyle(fontSize:17.0, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                        ],
                      ),
                    ),
                 ),

              ],
            ) :
            Row(

              children: [
                Flexible(flex:1,
                  child: Image.network(product.images?[0],
                  fit: BoxFit.cover,
                  height: 250.0,)),
                Flexible(
                  flex:1,
                  child:Container(
                    padding: EdgeInsets.all(8.0),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${product.description}', style: TextStyle(fontWeight: FontWeight.w800),),
                        Text('R\$ ${product.price}',
                          style: TextStyle(fontSize: 17.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ))

              ],

            ),
      )
    );
  }
}
