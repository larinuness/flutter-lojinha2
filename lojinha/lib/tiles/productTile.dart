import 'package:flutter/material.dart';
import 'package:lojinha/datas/productData.dart';
import 'package:lojinha/screens/productScreen.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    //Pode ser Inkell ou GestureDetector, inkell tem animaçãozinha legal haha
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProductScreen(product)));
      },
      child: Card(
        //se o tipo for grid pra ser uma coluna caso ao contrario vai ser uma linha
        child: type == "grid"
            ? Column(
                //strech pq vai ficar esticado, olha as blusa quando vai ficar mais esticada
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //start porque vai começar no topo sempre na lateral
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //pra deixar a imagem do mesmo tamanho independente do dispositivo
                  //divide a altura pela pela a larguta
                  AspectRatio(
                    aspectRatio: 0.8,
                    child: Image.network(
                      product.images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  //pega todos o espaco disponivel
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        //toStringAsFixed pra deixar com duas casas decimais depois da ,
                        Text(
                          'R\$ ${product.price.toStringAsFixed(2).replaceAll(".", ",")}',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
                ],
              )
            : Row(
                children: [
                  Flexible(
                    child: Image.network(
                      product.images[0],
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                    //flex 1 em cada pra ficar dividido em espaços iguais
                    flex: 1,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          //toStringAsFixed pra deixar com duas casas decimais depois da ,
                          Text(
                            'R\$ ${product.price.toStringAsFixed(2).replaceAll(".", ",")}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
