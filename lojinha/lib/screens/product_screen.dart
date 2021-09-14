import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lojinha/datas/cart_product.dart';
import 'package:lojinha/datas/product_data.dart';
import 'package:lojinha/models/cart_model.dart';
import 'package:lojinha/models/user_model.dart';

import 'cart_screen.dart';
import 'login_screen.dart';

class ProductScreen extends StatefulWidget {
  //recebemos o produto
  final ProductData product;

  ProductScreen(this.product);

  //passamos o produto para o nosso estado

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  //salva o produto aqui
  final ProductData product;

  String? size;

  //o estado recebe o produto
  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    //obtemos a cor no começo do build porque vamos usar ela em vários locais da tela

    final Color primaryColor = Theme.of(context).primaryColor;

    //da forma que fizemos acima é possível acessar diretamente as propriedades do product
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title!),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          //largura dividido pela altura
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              //pegamos cada uma das url da lista de imagens e transformo em uma imagem vinda do network, por fim transforma em lista
              images: product.images!.map((url) {
                return NetworkImage(url);
              }).toList(),
              //tamanho do ponto que fica na parte inferior que simboliza qual imagem estamos mostrando na tela
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              dotIncreasedColor: primaryColor,
              //o autoplay false não deixa ele ficar mudando as imagens automaticamente
              autoplay: false,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title!,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  //definindo quantidade máxima de linhas
                  maxLines: 3,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'R\$ ${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Tamanho',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                //quando quero especificar uma altura fixa, uso siezdBox também
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    //espaçamento embaixo e em cima
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //vai ter uma linha só
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    //pegamos o produto atual e a lista de tamanhos, mapeamos isso e transformamos em uma lista
                    children: product.sizes!.map((s) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = s;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                  color: s == size ? primaryColor : Colors.grey,
                                  width: 3.0)),
                          width: 50.0,
                          alignment: Alignment.center,
                          child: Text(s),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 44.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: primaryColor),
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? 'Adicionar ao Carrinho'
                          : 'Entre para comprar',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    //função que vai desabilitar o botão se não tiver tamanho escolhido
                    onPressed: size != null
                        ? () {
                            //usando o método criado no UserModel consigo acessar ele
                            //tanto na userModel quanto na navigator há uma procura de um objeto desse tipo na árvore
                            if (UserModel.of(context).isLoggedIn()) {
                              CartProduct cartProduct = CartProduct();
                              cartProduct.size = size!;
                              cartProduct.quantity = 1;
                              cartProduct.pid = product.id!;
                              cartProduct.category = product.category!;
                              cartProduct.productData = product;

                              CartModel.of(context).addCartItem(cartProduct);

                              //depois que adiciona algo no carrinho vai para a tela do carrinho
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            }
                          }
                        : null,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Descrição',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  product.description!,
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
