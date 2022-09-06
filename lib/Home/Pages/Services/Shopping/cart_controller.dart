import 'package:get/get.dart';
import 'package:monbang/Home/Pages/Services/Shopping/product_model.dart';

class CartController extends GetxController {
  var _products = {}.obs;

  void addProduct(Product product) {
    if (_products.containsKey(product)) {
      _products[product] += 1;
    } else {
      _products[product] = 1;
    }
  }

  void addAmount(Product product, int amount) {
    if (_products.containsKey(product)) {
      _products[product] += amount;
    } else {
      _products[product] = amount;
    }
  }

  void removeProduct(Product product) {
    if (_products.containsKey(product) && _products[product] == 1) {
      _products.removeWhere((key, value) => key == product);
    } else {
      _products[product] -= 1;
    }
  }

  get productSubTotal => _products.entries
      .map((product) => product.key.price * product.value)
      .toList();
  get productTotal => _products.entries
      .map((product) => product.key.price * product.value)
      .toList()
      .reduce((value, element) => value + element)
      .toString();

  get products => _products;
}
