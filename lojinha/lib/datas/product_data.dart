//fazer por classe pra não fica pegando apenas pelo o snapchot
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String? category;

  String? id;
  String? title;
  String? description;
  late double price;
  List? images;
  List? sizes;

  //pegamos o documento no firebase e transformamos nesses dados citados acima para criar o Product Data
  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot['title'];
    description = snapshot['description'];
    price = 0.0 + snapshot['price'];
    images = snapshot['images'];
    sizes = snapshot['sizes'];
  } //convertendo os dados do documento para os dados da nossa classe

  //função que resume as informações que queremos mostrar nos pedidos
  Map<String, dynamic> toResumedMap() {
    return {'title': title, 'description': description, 'price': price};
  }
}
