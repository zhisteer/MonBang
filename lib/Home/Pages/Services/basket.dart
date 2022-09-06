import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monbang/Home/Pages/Services/Shopping/cart_controller.dart';

import 'Shopping/product_model.dart';

class CartProducts extends StatelessWidget {
  final CartController controller = Get.find();

  CartProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Obx(
        () => Column(
          children: [
            SizedBox(
              height: 400,
              child: controller.products.length != 0
                  ? ListView.builder(
                      itemCount: controller.products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CartProductCard(
                          controller: controller,
                          product: controller.products.keys.toList()[index],
                          quantity: controller.products.values.toList()[index],
                          index: index,
                        );
                      })
                  : Center(child: Text("Таны сагс хоосон байна.")),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text("Нийт")),
                  Text("₮"),
                  controller.products.length != 0
                      ? Text(controller.productTotal)
                      : Text("0")
                ],
              ),
            ),
            TextButton(onPressed: () {}, child: Text("Захиалах"))
          ],
        ),
      ),
    );
  }
}

class CartProductCard extends StatelessWidget {
  final CartController controller;
  final Product product;
  final int quantity;
  final int index;
  CartProductCard(
      {Key? key,
      required this.controller,
      required this.index,
      required this.product,
      required this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int total = product.price * quantity;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(product.name)),
          IconButton(
              onPressed: () {
                controller.removeProduct(product);
              },
              icon: Icon(Icons.remove_circle)),
          Text("$quantity"),
          IconButton(
              onPressed: () {
                controller.addProduct(product);
              },
              icon: Icon(Icons.add_circle)),
          Text("₮$total")
        ],
      ),
    );
  }
}
