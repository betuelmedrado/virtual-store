

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/tiles/product_tile.dart';


class CategoryScreen extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot,{super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('${snapshot.get('title')}', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.amber ,
            tabs: [
              Tab(icon: Icon(Icons.grid_on, color: Colors.white)),
              Tab(icon: Icon(Icons.list, color: Colors.white,)),

            ]),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('products').doc(snapshot.id).collection('items').get(),

          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }else{
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    padding: EdgeInsets.all(4.0),
                    itemCount: snapshot.data?.docs.length ,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 0.63,
                    ),
                    itemBuilder: (context, index){
                      ProductsData data = ProductsData.fromDocuments(snapshot.data!.docs[index]);
                      data.category = this.snapshot.id;
                      return ProductTile('grid', data);
                    },
                  ),

                  ListView.builder(
                    padding: EdgeInsets.all(4.0),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index){
                      ProductsData data = ProductsData.fromDocuments(snapshot.data!.docs[index]);
                      data.category = this.snapshot.id;

                      return ProductTile('list',data);


                    } )

                ]);
            }

          })
      )
    );
  }
}
