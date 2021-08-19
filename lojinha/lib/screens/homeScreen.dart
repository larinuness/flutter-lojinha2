import 'package:flutter/material.dart';
import 'package:lojinha/tabs/homeTab.dart';
import 'package:lojinha/tabs/productsTab.dart';
import 'package:lojinha/widgets/customDrawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    //desliga entre telas
    return PageView(
      controller: _pageController,
      //não deixa da scrooll no pageview
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Categorias'),
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
        ),
      ],
    );
  }
}
