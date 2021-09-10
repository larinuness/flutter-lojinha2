import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  //model é um objeto que vai guardar os estados de alguma coisa
  //nesse caso vai armazenar o usuário atual e ter todas as funções que vão modificar o estado atual

  FirebaseAuth _auth = FirebaseAuth.instance;

  User? firebaseUser;

  //vai abrigar os dados do usuário
  Map<String, dynamic> userData = Map();

  //variável que vai indicar quando o UserModel tá processando algo
  bool isLoading = false;

  //método que vai me permitir acessar o userModel de qualquer lugar do app
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  //voidCallback, função que vamos passar e ela será chamada dentro da função
  void signUp(
      {required Map<String, dynamic> userData,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    try {
      UserCredential teste = await _auth.createUserWithEmailAndPassword(
          email: userData['email'], password: pass);

      //aqui tentamos criar nosso usuário
      //depois que processar isso, vai chamar a função
      firebaseUser = teste.user;

      //para salvar os dados no firestore
      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  void signIn(
      {required String email,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    isLoading = true;
    //para mostrar que modificou algo no modelo e que a view precisa ser atualizada usamos o notify
    //o notify vai recriar tudo que estiver dentro do scopedmodeldescendant
    notifyListeners();

    try {
      UserCredential teste =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      firebaseUser = teste.user;

      await _loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void recoverPass(String email) {
    //função do firebase para recuperação de senha
    _auth.sendPasswordResetEmail(email: email);
  }

  //usamos _ para funções internas
  //salvamos os dados na coleção users no documento correspondente ao id do usuário
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .set(userData);
  }

  //se o firebaseUser for diferente de nulo ele vai retornar true indicando que tem um usuário logado
  bool isLoggedIn() {
    return firebaseUser != null;
  }

  //função para pegar os dados do usuário do banco de dados
  Future<Null> _loadCurrentUser() async {
    //verifica se o usuário é nulo e se for o caso, ou seja, não tenho nenhum usuário já logado, vou tentar pegar os dados do usuário atual
    if (firebaseUser == null) firebaseUser = _auth.currentUser;

    //se ele for diferente de nulo quer dizer que logou, então vou pegar os dados
    if (firebaseUser != null) {
      if (userData['name'] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser!.uid)
            .get();
        userData = docUser.data() as Map<String, dynamic>;
      }
    }
    notifyListeners();
  }
}
