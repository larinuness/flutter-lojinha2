import 'package:flutter/material.dart';
import 'package:lojinha/tabs/home_tab.dart';
import 'package:lojinha/tabs/products_tab.dart';
import 'package:lojinha/widgets/custom_drawer.dart';

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
            title: Text('Produtos'),
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
        ),
      ],
    );
  }
}
