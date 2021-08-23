import 'package:flutter/material.dart';
import 'package:lojinha/models/userModel.dart';
import 'package:lojinha/screens/loginScreen.dart';
import 'package:lojinha/tiles/drawerTile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    //função do degrade
    Widget _buildDrawerBack() {
      return Container(
          decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 203, 236, 241),
            Colors.white,
          ],
          //onde começa e termina
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ));
    }

    //colocar o botao de tipo uma navbar
    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 16),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                //Stack e melhor pra posicionar, mas poderia ser um column
                //no caso vai ser stack pra poder deixar alinhados as coisas
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      left: 0,
                      // o \n pula linha
                      child: Text(
                        "Flutter's \nClothing",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context,child,model){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Olá, ${!model.isLoggedIn() ? "" : model.userData['name']}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Text(!model.isLoggedIn() ?
                                  'Entre ou Cadastre-se' : "Sair",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  if(!model.isLoggedIn())
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginScreen())
                                  );
                                  else
                                    model.signOut();
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              //os numero pra saber qual pagina é qual
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(Icons.list, "Produtos", pageController, 1),
              DrawerTile(Icons.location_on, "Lojas", pageController, 2),
              DrawerTile(
                  Icons.playlist_add_check, "Meus pedidos", pageController, 3),
            ],
          ),
        ],
      ),
    );
  }
}
