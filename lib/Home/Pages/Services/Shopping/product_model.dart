import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final int price;
  final String type;
  const Product({required this.name, required this.price, required this.type});
  static Product fromSnapshot(DocumentSnapshot snap) {
    Product product =
        Product(name: snap['name'], price: snap['price'], type: snap['type']);
    return product;
  }
}
