
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/user_model.dart';


class CustomDrawer extends StatelessWidget {

  final PageController page_controller;


  const CustomDrawer(this.page_controller, {super.key});


  @override
  Widget build(BuildContext context) {

    // Create the back color
    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
          Color.fromARGB(255, 203, 236, 241),
          Colors.white
        ]),
      ),
    );

    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0 , top: 16.0),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height:230.0,
                child: Stack(
                  children: [
                    Positioned(
                      top: 8.0,
                      left:0.0,
                      child: Text('Flutter`s\nClothing', style: TextStyle(fontSize: 43.0, fontWeight: FontWeight.bold))),

                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Olá,${model.isLoggedIn() ? '${model.userData['name']}' : ''}',style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),),
                              GestureDetector(
                                child:Text('${model.isLoggedIn() ? 'Sair' : 'Entre ou cadastre >' }',
                                    style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                                onTap:(){

                                  if(!model.isLoggedIn()){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                                   }else{
                                    model.signOut();

                                  }
                                }

                              ),
                            ],
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTiles(Icons.home, 'Inicio', this.page_controller, 0),
              DrawerTiles(Icons.list, 'Produto',this.page_controller, 1),
              DrawerTiles(Icons.location_on, 'Lojas', this.page_controller, 2),
              DrawerTiles(Icons.playlist_add_check, 'Meus pedidos',this.page_controller, 3),


            ],
          ),
        ],
      ),
    );
  }
}
