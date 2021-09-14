import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojinha/models/cart_model.dart';

class DiscountCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      //expansionTile é uma tile que vai se expandir quando clicada e mostrar o restante do conteúdo
      child: ExpansionTile(
        title: Text(
          'Cupom de Desconto',
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        //ícone da parte esquerda
        leading: Icon(Icons.card_giftcard),
        //ícone da parte direita
        trailing: Icon(Icons.add),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Digite seu cupom'),
              //texto inicial que o TextFormField vai ter
              //quando abrir vai colocar o código de cupom que tá aplicado ou deixar em branco
              initialValue: CartModel.of(context).couponCode ?? '',
              //quando digitar o cupom e pressionar o concluído vai aplicar esse cupom
              onFieldSubmitted: (text) {
                FirebaseFirestore.instance
                    .collection('coupons')
                    .doc(text)
                    .get()
                    .then((docSnap) {
                  //não entendi o que é esse docSnap
                  //entendi que a função anônima vai conter isso, mas não o que é
                  //seria o texto do cupom?
                  //aqui verifica se o cupom existe no banco de dados, mas teoricamente ele não pode vir nulo
                  if (docSnap.data != null) {
                    CartModel.of(context).setCoupon(text, docSnap['percent']);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Desconto de ${docSnap['percent']}% aplicado!"),
                      backgroundColor: Theme.of(context).primaryColor,
                    ));
                  } else {
                    CartModel.of(context).setCoupon('', 0);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Cupom não existente"),
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                  //não tá entrando no else, eu entendi que deveria entrar no else quando digita um cupom diferente do existente na coleção
                });
              },
            ),
          )
        ],
      ),
    );
  }
}