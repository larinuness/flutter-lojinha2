import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojinha/tiles/order_tile.dart';

import '../models/user_model.dart';
import '../screens/login_screen.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      //precisamos do uid para entrar no perfil do usuário e obter todos os pedidos
      String uid = UserModel.of(context).firebaseUser!.uid;

      //acessando a coleção orders e pegando todos os pedidos do usuário
      return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('orders')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs
                    .map((doc) {
                      doc.data() as Map<String, dynamic>;
                      return OrderTile(doc.id);
                    })
                    .toList()
                    .reversed
                    .toList(),
              );
            }
          });
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          //ocupar o espaço inteiro na horizontal da coluna
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag,
                size: 80.0, color: Theme.of(context).primaryColor),
            SizedBox(height: 16.0),
            Text('Faça o login para acompanhar!',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
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
    }
  }
}