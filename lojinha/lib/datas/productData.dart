//fazer por classe pra não fica pegando apenas pelo o snapchot
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  late String id;
  late String title;
  late String description;
  late double price;
  late List images;
  late List sizes;
  late String category;
  //função que vai receber os dados do firebase
  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot['title'];
    description = snapshot['description'];
    price = snapshot['price'];
    images = snapshot['images'];
    sizes = snapshot['sizes'];
  }
  
  //função que resume as informações que queremos mostrar nos pedidos
  Map<String, dynamic> toResumedMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
    };
  }
}
