import 'package:flutter/material.dart';
import 'package:lojinha/models/cart_model.dart';
import 'package:lojinha/models/user_model.dart';
import 'package:lojinha/tiles/cart_tile.dart';
import 'package:lojinha/widgets/cart_price.dart';
import 'package:lojinha/widgets/discount_card.dart';
import 'package:lojinha/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

import 'login_screen.dart';
import 'order_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
        actions: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p = model.products.length;
                return Text(
                  //se p for nulo vai retornar 0, se não retorna o valor de p
                  "$p ${p == 1 ? "ITEM" : "ITENS"}",
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          )
        ],
      ),
      //todo o corpo sera feito dependendo do cartModel e sempre que algo mudar no carrin ho a tela será refeita
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                //ocupar o espaço inteiro na horizontal da coluna
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart,
                      size: 80.0, color: Theme.of(context).primaryColor),
                  SizedBox(height: 16.0),
                  Text('Faça o login para adicionar produtos!',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      'Entrar',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                  )
                ],
              ),
            );
          } else if (model.products.length == 0) {
            return Center(
              child: Text('Nenhum produto no carrinho!',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            );
          } else {
            return ListView(
              children: [
                Column(
                  //mapeando os produtos da lista
                  //pegando a lista de produtos e transformando em widgets
                  children: model.products.map((product) {
                    return CartTile(product);
                  }).toList(),
                ),
                DiscountCart(),
                ShipCard(),
                CartPrice(() async {
                  String orderId = await model.finishOrder();
                  if (orderId != '') {
                    //substitui a tela do carrinho pela tela do pedido
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => OrderScreen(orderId)));
                  }
                }),
              ],
            );
          }
        },
      ),
    );
  }
}