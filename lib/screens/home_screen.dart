
import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/order_tabe.dart';
import 'package:loja_virtual/tabs/products_tab.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

import '../tabs/place_tabe.dart';
import '../widgets/cart_button.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return  PageView(
      controller: _pageController,
      // physics: NeverScrollableScrollPhysics(), // Para não mudar de tela arrastando para o lado
      children: [
        // Primeira pagina 0
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),

        // Segunda pagina 1
        Scaffold(
          drawer: CustomDrawer(_pageController),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('Produtos', style: TextStyle(color:Colors.white)),
          ),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),

        // Terceira pagina 2
       Scaffold(
         drawer: CustomDrawer(_pageController),
         appBar: AppBar(
           backgroundColor: Theme.of(context).primaryColor,
           centerTitle: true,
           title:Text('Locais', style:TextStyle(color: Colors.white)),
         ),
         body:PlaceTabe(),
       ),

        // Quarta pagina 3
        Scaffold(
          drawer: CustomDrawer(_pageController),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title:Text('Meus Pedidos', style: TextStyle(color:Colors.white),),
            centerTitle: true,
          ),
          body:OrderTabe(),

        ),
        // Quinta pagina 4
        Container(color: Colors.cyan,),


      ],
    );
  }
}
