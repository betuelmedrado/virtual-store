import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'model/user_model.dart';
import 'model/cart_model.dart';

void main() async{

  // Para garantir que o app inicialize corretamente
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child:ScopedModelDescendant<UserModel>(
        builder: (context,child, model){
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter`s Clothing',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 4, 125, 141),
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),

              ),
              home: HomeScreen(),

            ),);
        })
    );
  }
}

