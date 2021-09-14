import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../datas/cart_product.dart';
import 'user_model.dart';

class CartModel extends Model {
  UserModel user;

  List<CartProduct> products = [];

  String? couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.id;
    });
    //o then é para, depois de adicionar o produto no carrinho, salvar o id gerado no firebase nas variáveis de id que criamos
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void _loadCartItems() async {
    //pega todos os documentos da coleção cart
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .get();

    //transformo cada documento que retornei do firebase e retorno uma lista com todos os CartProducts
    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  double getProductsPrice() {
    double price = 0.0;

    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity * c.productData!.price;
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  void updatePrices() {
    notifyListeners();
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return '';

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double discount = getDiscount();
    double shipPrice = getShipPrice();

    //adicionar as ordens no firebase
    //recupero o id do pedido a partir da referência do pedido
    DocumentReference refOrder =
        await FirebaseFirestore.instance.collection('orders').add({
      'clientID': user.firebaseUser!.uid,
      //mapeamos a lista de produtos transformando cada cartProduct em um mapa, no firestore é armazenado sempre mapas
      'products': products.map((cartProduct) => cartProduct.toMap()).toList(),
      'shipPrice': shipPrice,
      'productsPrice': productsPrice,
      'discount': discount,
      'totalPrice': productsPrice - discount + shipPrice,
      'status': 1
    });

    //salvamos o orderID dentro do usuário
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('orders')
        .doc(refOrder.id)
        .set({'orderID': refOrder.id});

    //remover todos os produtos, inclusive do firebase
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .get();

    //pego cada um dos documentos na lista do carrinho, a referência dele e deleta
    for (DocumentSnapshot doc in query.docs) {
      doc.reference.delete();
    }

    //limpo a lista local
    products.clear();

    couponCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();

    //retornamos isso para poder pegar o id desse pedido para um retorno desse id ao usuário
    return refOrder.id;
  }
}
