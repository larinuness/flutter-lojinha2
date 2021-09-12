import 'package:lojinha/datas/cart_product.dart';
import 'package:lojinha/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  //vai ter todos os produtos
  List<CartProduct> products = [];

  UserModel user;

  CartModel(this.user);
}
