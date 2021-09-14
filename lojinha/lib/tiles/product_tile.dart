import 'package:flutter/material.dart';
import 'package:lojinha/datas/product_data.dart';
import 'package:lojinha/screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    //usamos inkwell para poder tocar diretamente nele, poderíamos usar o GestureDetector também, as diferença é a animação no toque
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductScreen(product)));
      },
      child: Card(
          child: type == 'grid'
              ? Column(
                  //usamos o stretch porque a imagem está esticada
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  //imagem ficam  no início do card
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AspectRatio(
                      //defini a altura
                      aspectRatio: 0.8,
                      child: Image.network(
                        product.images![0],
                        fit: BoxFit.cover,
                      ),
                    ),
                    //precisamos que os textos peguem todo o espaço disponível
                    Expanded(
                        //colocando um container para dar um espaçamento
                        child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  product.title!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  'R\$ ${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15.0,
                                  ),
                                )
                              ],
                            )))
                  ],
                )
              : Row(
                  children: [
                    //deixando exatamente o mesmo espaço para a imagem e para o texto
                    Flexible(
                      flex: 1,
                      child: Image.network(
                        product.images![0],
                        fit: BoxFit.cover,
                        height: 250.0,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                'R\$ ${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17.0,
                                ),
                              )
                            ],
                          )),
                    )
                  ],
                )),
    );
  }
}
