import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

//Model objeto que vai guarda os estados do app
//vai ter estados e as funções que muda os estados
class UserModel extends Model {
  //classe do userAtual

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser

  //pega os dados mais importante do user, nome, email, senha e endereço
  Map<String, dynamic> userData = Map();

  //se vai está processando algo
  bool isLoading = false;

  //função pra fazer cadastro
  //está em {} mas é obrigatorio, porém agora não importa a ordem
  void signUp(
      {required Map<String, dynamic> userData,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) {
    //primeiro está carregando
    isLoading = true;
    //notifica o usuario
    notifyListeners();
    //tenta criar user
    _auth
        .createUserWithEmailAndPassword(
      email: userData['email'],
      password: pass,
      //se funcionar vai pro then, se não pro catch
    )
        .then((user) async {
      //salve o user
      firebaseUser = user as User;
      //salva os dados do user
      await _saveUserData(userData);
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  //função pra fazer login
  void signIn(
      {required String email,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    isLoading = true;
    //avisa que teve mudança
    notifyListeners();
    _auth.signInWithEmailAndPassword(email: email, password: pass).then((user){
      firebaseUser = user as User?;

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  //funçaõ pra recuperar senha
  void recoverPass() {}

  //salva o user data
  Future _saveUserData(Map<String, dynamic> userData) async {
    //passa o user data da função para o atributo(map) lá em cima
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .set(userData);
  }

  //função se está logado ou não
  bool isLoggedIn() {
    return firebaseUser != null;
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
  }
//função pra saber se está logado
/*bool isLoggedIn(){
  }*/

}
