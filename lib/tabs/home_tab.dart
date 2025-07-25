import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';


class HomeTab extends StatelessWidget {
  const HomeTab({super.key});


  @override
  Widget build(BuildContext context) {

    // Decorando um Container() com um degrade para colocar no background do widget Steck()
    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,   // A onde o gradiente começa
          end: Alignment.bottomRight,  // A onde o gradienter termina
          colors: [
            Color.fromARGB(255, 211, 118, 130),
            Color.fromARGB(255, 253, 181, 168)
          ]),
      ),
    );

    // Stack adiciona os widget em cima do outro
    return Stack(
      children: [
        _buildBodyBack(),
        CustomScrollView(
          slivers: [
            // Uma Barra ########
            SliverAppBar(
              floating: true, // Vai ser do tipo flutuante
              snap: true,  // Quando puchar a lista para baixo a barra some
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Novidades', style: TextStyle(fontWeight: FontWeight.bold ,color: Colors.white, ),),
                centerTitle: true,
              ),
            ),

            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('home').orderBy('pos').get(),
              builder: (context, snapshot){
                if(!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                    ),
                  );
                }else {

                  return SliverToBoxAdapter(
                    child: GridView.custom(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        pattern: [

                          QuiltedGridTile(2, 2),
                          QuiltedGridTile(1, 2),
                          QuiltedGridTile(2, 1),
                          QuiltedGridTile(1, 1),
                          QuiltedGridTile(1, 1),

                        ],
                      ),
                      childrenDelegate: SliverChildBuilderDelegate(
                            (context, index) => FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: snapshot.data!.docs[index]['image'],
                          fit: BoxFit.cover,
                        ),
                        childCount: snapshot.data!.docs.length,
                      ),
                    ),
                  );
                }
              })
          ],
        ),
      ],
    );
  }
}



// StaggeredGrid.count(
// crossAxisCount: 2,
// crossAxisSpacing: 1.0,
// mainAxisSpacing:1.0,
// children: [
// StaggeredGridTile.count(
// crossAxisCellCount: crossAxisCellCount, mainAxisCellCount: mainAxisCellCount, child: child)
//
// ],
//
// );