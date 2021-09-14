import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojinha/datas/product_data.dart';
import 'package:lojinha/tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    //sistema para mudar as tabs(modo de visualização dos produtos)
    return DefaultTabController(
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
                  )
                ],
              ),
            ),
            //formas como queremos mostrar os produtos no corpo quando selecionada uma das opções acima(grade ou lista)
            //query snapshot é tipo uma fotografia de uma coleção, ou seja, pode acessar a fotografia de cada um dos documentos, enquanto o document snapshot é a fotografia de um documento
            body: FutureBuilder<QuerySnapshot>(
              //pegando os dados do servidos através do futureBuilder
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
                else {
                  return TabBarView(
                    //com esse método o usuário não pode arrastar a telara para o lado
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      //.builder ele vai carregar os produtos aos poucos para a tela não ficar tão pesada
                      GridView.builder(
                          padding: EdgeInsets.all(4.0),
                          //o Delegate vai falar quantos itens vou ter na horizonta e qual vai ser o espaçamento entre os itens
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  //razão entre a largura para altura
                                  childAspectRatio: 0.65),
                          //especifica quantos itens vou ter na grade e recebe todos os documentos
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            ProductData data = ProductData.fromDocument(
                                snapshot.data!.docs[index]);
                            //salvo a categoria do produto dentro do próprio produto para que possa ser utilizada novamente depois
                            data.category = this.snapshot.id;

                            //vai retornar o item que vamos mostrar em cada posição
                            //pegando a lista de documentos (docs) através do index passado no construtor dessa função anônima, transformando em um objeto ProductData
                            //para gerenciar os dados, e passo esse productData para o ProductTile
                            return ProductTile('grid', data);
                            //essa conversão facilita caso no futuro seja necessário alterar para outro banco de dados, nesse caso será necessário alterar apenas a classe ProductData
                          }),
                      ListView.builder(
                          padding: EdgeInsets.all(4.0),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            ProductData data = ProductData.fromDocument(
                                snapshot.data!.docs[index]);
                            //salvo a categoria do produto dentro do próprio produto para que possa ser utilizada novamente depois
                            data.category = this.snapshot.id;

                            return ProductTile('list', data);
                          })
                    ],
                  );
                }
              },
            )));
  }
}
