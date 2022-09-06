import 'package:get/get.dart';
import 'package:monbang/Home/Pages/Services/Shopping/firebaseDB.dart';

import 'product_model.dart';

class ProductController extends GetxController {
  final products = <Product>[].obs;

  @override
  void onInit() {
    products.bindStream(FirestoreDB().getAllProducts());
    super.onInit();
  }
}
