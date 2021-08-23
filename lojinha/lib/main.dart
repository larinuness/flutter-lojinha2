// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lojinha/models/userModel.dart';
import 'package:lojinha/screens/homeScreen.dart';
import 'package:scoped_model/scoped_model.dart';

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
    return ScopedModel<UserModel>(model: UserModel(), child: MaterialApp(
      title: "Flutter's Clothing",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 4, 125, 141),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    )
    );
  }
}


