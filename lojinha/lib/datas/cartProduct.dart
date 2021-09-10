import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojinha/datas/productData.dart';

class CartProduct {
  late String cid;
  late String category;
  late String pid;
  late int quantity;
  late String size;

  late ProductData productData;
 
  //transforma em um cartProduct
  CartProduct.fromDocument(DocumentSnapshot document) {
    cid = document.id;
    category = document['category'];
    pid = document['pid'];
    quantity = document['quantity'];
    size = document['size'];
  }
  
  //add no branco
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'pid': pid,
      'quantity': quantity,
      'size': size,
      //aqui vamos armazear só um resumo do produto porque no acompanhamento dos pedidos quero um resumo de cada um dos produtos
      'product': productData.toResumedMap(),
    };
  }
}
