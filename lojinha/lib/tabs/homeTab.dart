import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //função do degrade
    Widget _buildBodyBack() {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(255, 253, 181, 168),
              ],
              //onde começa e termina
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
      );
    }

    return Stack(
      children: [
        _buildBodyBack(),
        //barra que não é fixa, flutuante
        CustomScrollView(
          slivers: [
            SliverAppBar(
              //efeotp de desaparecer
              floating: true,
              //efeito de reaparecer
              snap: true,
              backgroundColor: Colors.transparent,
              //elevação 0 pra não ter sombreado
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Novidades'),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection("home")
                  .orderBy("pos")
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                else
                  return SliverStaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    staggeredTiles: snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final x = data['x'];
                      final y = 0.0 + data['y'];
                      return StaggeredTile.count(x, y);
                    }).toList(),
                    children: snapshot.data!.docs.map((doc) {
                      //Fade pra vir de forma mais natural
                      return FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: doc['image'],
                        fit: BoxFit.cover
                      );
                    }).toList(),
                  );
              },
            ),
          ],
        ),
      ],
    );
  }
}
