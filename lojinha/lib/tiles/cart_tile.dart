import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../datas/cart_product.dart';
import '../datas/product_data.dart';
import '../models/cart_model.dart';

class CartTile extends StatelessWidget {
  //aqui no cartTile precisamos recuperar as informações do produto que tem no banco de dados

  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      //para notificar que algo mudou
      //quando carregar o preço do produto vai atualizar o valores
      CartModel.of(context).updatePrices();

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //primeiro dado é a imagem, para setar largura fixa uso um container ao redor
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartProduct.productData!.images![0],
              fit: BoxFit.cover,
            ),
          ),
          //uso expanded para cobrir todo o resto da área do card que sobrar
          Expanded(
              //uso container para dar mais um espaçamento em toda a lateral
              child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cartProduct.productData!.title!,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                ),
                Text(
                  "Tamanho: ${cartProduct.size}",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(
                  "R\$ ${cartProduct.productData!.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: cartProduct.quantity > 1
                          ? () {
                              CartModel.of(context).decProduct(cartProduct);
                            }
                          : null,
                      icon: Icon(Icons.remove),
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(cartProduct.quantity.toString()),
                    IconButton(
                      onPressed: () {
                        CartModel.of(context).incProduct(cartProduct);
                      },
                      icon: Icon(Icons.add),
                      color: Theme.of(context).primaryColor,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        CartModel.of(context).removeCartItem(cartProduct);
                      },
                      child: Text(
                        'Remover',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                    ),
                  ],
                )
              ],
            ),
          ))
        ],
      );
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        //se os dados ainda não tiverem sido salvos na sessão do usuário, precisamos pegar no firestore
        //nesse caso setei o productData como late e não deixei a opção de ser nulo, então essa validação não faz sentido
        // ignore: unnecessary_null_comparison
        child: cartProduct.productData == null
            ? FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('products')
                    .doc(cartProduct.category)
                    .collection('items')
                    .doc(cartProduct.pid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    cartProduct.productData =
                        ProductData.fromDocument(snapshot.data!);
                    return _buildContent();
                  } else {
                    return Container(
                      height: 70.0,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  }
                },
              )
            : _buildContent());
  }
}