import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lojinha/datas/productData.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;


  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  String? size;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 4,
              dotSpacing: 15,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  //toStringAsFixed pra deixar com duas casas decimais depois da ,
                  'R\$ ${product.price.toStringAsFixed(2).replaceAll(".", ",")}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Tamanho',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34,
                  //gridview pra exibir os quadradinhos de tamanho com espaco entre eles
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      // 1 porque vai ser uma linh só
                        crossAxisCount: 1,
                      //apenas o mainAxis vai ser apenas um do lado do outro, se tivess embaixo, colocaria o crossAxis tbm
                      mainAxisSpacing: 8,
                      //divisao por altura e largura
                      childAspectRatio: 0.5
                    ),
                    children: product.sizes.map((s) {
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            size = s;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              //se s for igual a size, vai por primary color se não vai ser cinza normal
                              color: s == size ? primaryColor : Colors.black26,
                              width: 2
                            ),
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(s),
                        ),
                      );
                    }).toList()
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
