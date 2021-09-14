import 'package:cloud_firestore/cloud_firestore.dart';

import 'product_data.dart';

class CartProduct {
  //id do produto no carrinho ou id da categoria
  late String cid;

  //categoria do produto (calças, camisetas)
  late String category;

  //id do produto
  late String pid;

  //caso haja alguma alteração no produto, a quantidade que o usuário colocou no carrinho não vai mudar, então podemos armazenar
  late int quantity;
  late String size;

  //não armazenamos os dados dos produtos no carrinho permanentemente, mas quando abrir o carrinho vou precisar carregar estes dados
  ProductData? productData;

  CartProduct();

  //pegamos um documento armazenado na nossa conta e transformamos em um cartProduct
  CartProduct.fromDocument(DocumentSnapshot document) {
    cid = document.id;
    category = document['category'];
    pid = document['pid'];
    quantity = document['quantity'];
    size = document['size'];
  }

  //agora fazemos o contrário, adicionamos no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'pid': pid,
      'quantity': quantity,
      'size': size,
      //aqui vamos armazear só um resumo do produto porque no acompanhamento dos pedidos quero um resumo de cada um dos produtos
      'product': productData!.toResumedMap(),
    };
  }
}