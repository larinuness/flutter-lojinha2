import 'package:flutter/material.dart';
import 'package:lojinha/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  //key para usarmos o scaffold dentro da função success e fail
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _adressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Criar Conta'),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );

            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Nome Completo'),
                    validator: (text) {
                      if (text!.isEmpty) return 'Nome inválido!';
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text!.isEmpty || !text.contains('@'))
                        return 'Email inválido!';
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(hintText: 'Senha'),
                    //não mostra a senha digitada
                    obscureText: true,
                    validator: (text) {
                      if (text!.isEmpty || text.length < 6)
                        return 'Senha inválida!';
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _adressController,
                    decoration: InputDecoration(hintText: 'Endereço'),
                    validator: (text) {
                      if (text!.isEmpty) return 'Endereço inválido!';
                    },
                  ),
                  //usamos o align para alinhar o botão
                  SizedBox(
                    height: 16.0,
                  ),
                  //usamos sizedbox aqui para deixar o botão mais alto
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        //aqui pedimos para validar nossos campos
                        if (_formKey.currentState!.validate()) {
                          //salvamos os dados do usuário em um userData, a senha não é armazenada junto com as informações do usuário
                          Map<String, dynamic> userData = {
                            'name': _nameController.text,
                            'email': _emailController.text,
                            'adress': _adressController.text,
                          };

                          model.signUp(
                              userData: userData,
                              pass: _passController.text,
                              onSuccess: _onSuccess,
                              onFail: _onFail);
                        }
                      },
                      child: Text(
                        'Criar Conta',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    //sair da tela depois de mostrar a snackbar
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}


