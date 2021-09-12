import 'package:flutter/material.dart';
import 'package:lojinha/models/user_model.dart';
import 'package:lojinha/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  //assim que for pra uma tela não vai poder volta pra tela anterior, tipo fica block
                  //parecido com o pushandremoveuntil
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
            child: Text(
              'Criar Conta',
              style: TextStyle(fontSize: 15),
            ),
          )
        ],
      ),
      //Forma de acessar o modelo(UserModel) sem construtor
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            //se tiver carreango mostra a progress bar
            return Center(
              child: CircularProgressIndicator(),
            );
          //se nao, mostra o form
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text!.isEmpty || !text.contains('@'))
                      return 'E-mail inválido';
                  },
                  decoration: InputDecoration(
                      hintText: 'E-mail',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor))),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      hintText: 'Senha',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor))),
                  obscureText: true,
                  validator: (text) {
                    if (text!.isEmpty || text.length < 6)
                      return 'Senha inválida';
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        _scaffoldKey.currentState?.showSnackBar(SnackBar(
                          content: Text("Insira seu email para recuperar!"),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        model.recoverPass(_emailController.text);
                        _scaffoldKey.currentState?.showSnackBar(SnackBar(
                          content: Text("Confira seu email"),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    child: Text(
                      'Esqueci minha senha',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                      model.signIn(
                          email: _emailController.text,
                          pass: _passwordController.text,
                          onFail: _onFail,
                          onSuccess: _onSuccess);
                    },
                    child: Text(
                      'Entrar',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSuccess() {
    //em caso de sucesso no login ele volta para a página inicial
    Navigator.of(context).pop();
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Falha ao entrar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}