// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lojinha/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/cart_model.dart';
import 'models/user_model.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //tudo que estiver abaixo do ScopedModel vai ter acesso ao usermodel
    // e pode ser modificado caso algo acontecer no UserModel
    return ScopedModel<UserModel>(
      model: UserModel(),
      //CartModel abaixo do user porque ele precisa ter acesso ao usuário atual e aqui consigo acessar o modelo do carrinho de qualquer parte do código
      //descendant porque a cada troca de usuário preciso que o carrinho seja refeito
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: "Jade's Clothing",
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 4, 125, 141),
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}


