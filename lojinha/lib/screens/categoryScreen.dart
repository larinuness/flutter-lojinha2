import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojinha/datas/productData.dart';
import 'package:lojinha/tiles/productTile.dart';

class CategoryScreen extends StatelessWidget {
  //recebe o id da categoria e o titulo
  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      //quantas tabs ira ter, no caso 2
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot['title']),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.grid_on),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        //DocumentSnapshot é apenas uma fotogradia de apenas um doc
        // O query é fotografia de uma coleção, pode acessar a fotografia de cada coleção
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('products')
              .doc(snapshot.id)
              .collection('items')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else
              return TabBarView(
                children: [
                  //.builder porque vai carregando conforme vai descendo a tela, não é de uma vez, assim não fica lento o pc
                  GridView.builder(
                      padding: EdgeInsets.all(4),
                      //quantos item vai ter na horizontal
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //2 items na horizontal
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          childAspectRatio: 0.65),
                      //pega todos os documentos
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        //pega cada documento e transforma em um objeto Product Data, e passa pro productdata
                        return ProductTile(
                            "grid",
                            ProductData.fromDocument(
                                snapshot.data!.docs[index]));
                      }),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      //pega cada documento e transforma em um objeto Product Data, e passa pro productdata
                      return ProductTile("list",
                          ProductData.fromDocument(snapshot.data!.docs[index]));
                    },
                    padding: EdgeInsets.all(4),
                    itemCount: snapshot.data!.docs.length,
                  ),
                ],
              );
          },
        ),
      ),
    );
  }
}
