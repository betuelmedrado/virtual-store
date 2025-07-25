

import 'package:flutter/material.dart';
import 'package:loja_virtual/data/cart_product.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import '../data/products_data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loja_virtual/model/cart_model.dart';

import '../model/user_model.dart';


class ProductScreen extends StatefulWidget {

  final  ProductsData product;

  ProductScreen(this.product, {super.key});

  @override                                               // Passei o this.profuct aqui para o estate
  State<ProductScreen> createState() => _ProductScreenState(this.product);
}


class _ProductScreenState extends State<ProductScreen> {
  // crie o construtor aqui para receber o widget.product para não ter que sempre ficar chamando o widget
  final ProductsData product;
  // Construtor  que esta recebendo o widget.product
  _ProductScreenState(this.product);

  int _current = 0;
  String? size;
  final CarouselSliderController _carousel_controller = CarouselSliderController();


  @override
  Widget build(BuildContext context) {

    final Color primarycolor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text('${product.title}', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: CarouselSlider(
              carouselController: _carousel_controller,
              items: product.images?.map((url){
                return Image.network(url, fit: BoxFit.cover);
              }).toList(),
              options: CarouselOptions(
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: 1.0,
                // enlargeStrategy: CenterPageEnlargeStrategy.height,
                onPageChanged: (index, reason) {
                  setState(() {
                      _current = index;
                  });
                },
              ),),
          ),

          // Parte das bolinhas em baixo da image /////////////////////////////////
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 0,
            children: product.images!.asMap().entries.map((entry){
                return GestureDetector(
                  onTap: () => _carousel_controller.animateToPage(entry.key),
                  child: Container(
                    height:10.0,
                    width: 15.0,
                    child:CircleAvatar(
                      backgroundColor: Colors.black87.withOpacity(entry.key == _current ? 0.9 : 0.5 ),
                    ),
                  ),
                );
              _current++;
            }).toList(),
          ),

          Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${product.title}',
                  maxLines: 3,
                  style:TextStyle(fontSize:20.0)),
                Text('R\$ ${product.price!.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21.0, color: primarycolor)),

                SizedBox(height: 25.0,),

                Text('Tamanhos', style: TextStyle(fontSize: 17.0),),
                SizedBox(
                  height:34.0,
                  child: GridView(
                    // padding:EdgeInsets.symmetric(vertical:4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    children: product.sizes!.map((s){
                      return GestureDetector(
                        onTap:(){
                          setState((){
                            size = s;
                          });
                        },
                        child: Container(
                          width: 50.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            border: Border.all(color: size == s ? primarycolor : Colors.grey.shade500,
                              width:4.0,
                            ),
                          ),
                          child: Text('${s}', style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height:25.0),

                SizedBox(
                  height: 54.0,
                  child: ElevatedButton(

                    onPressed: size != null ? (){
                      // Poderia usar o ScopedModel também
                      if(UserModel.of(context).isLoggedIn()){

                        CartProduct cart_product = CartProduct();
                        cart_product.size = size;
                        cart_product.quantity = 1;
                        cart_product.p_id = product.id;
                        cart_product.category = product.category;

                        CartModel.of(context).addCartItem(cart_product);
                        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>CartScreen()));

                      }else{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                      }

                    } : null ,
                    child: Text( UserModel.of(context).isLoggedIn() ? 'Adicinar ao carrinho!' : 'Entre para comprar', style: TextStyle(fontSize: 23.0, color: size != null ? Colors.white : Colors.grey)),
                    style: TextButton.styleFrom(
                      backgroundColor: size != null ? primarycolor : null ,
                      fixedSize: Size(1000.0, 500.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),

                SizedBox(height:25.0),

                Text('Descrição', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                Text(product.description.toString(), style: TextStyle(fontSize: 20.0),),

              ],
            ),
          ),

        ],
      ),
    );
  }
}


// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// // .asMap() vai transformar minhas lista em map e "entryes" me da a chave e valor
// children: product.images!.asMap().entries.map((entry) {
// return GestureDetector(
// onTap: () => _carousel_controller.animateToPage(entry.key),
// child: Container(
// width: 8.0,
// height: 8.0,
// margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// color: (Theme.of(context).brightness == Brightness.dark
// ? Colors.white
//     : Colors.black).withOpacity(_current == entry.key ? 0.9 : 0.4)),
// ),
// );
// }).toList(),
// ),