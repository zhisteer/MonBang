import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monbang/Home/Pages/Services/Shopping/cart_controller.dart';
import 'package:monbang/Home/Pages/Services/Shopping/product_model.dart';
import 'package:monbang/Home/Pages/Services/add_item.dart';
import 'package:monbang/Home/Pages/Services/basket.dart';
import 'package:monbang/Home/Pages/Services/column_builder.dart';
import 'package:monbang/Home/Pages/Services/menu_item.dart';
import 'package:monbang/Home/Pages/Services/storage_services.dart';

import 'services.dart';

class MahScreen extends StatefulWidget {
  MahScreen({Key? key}) : super(key: key);

  @override
  State<MahScreen> createState() => _MahScreenState();
}

class _MahScreenState extends State<MahScreen> {
  FirebaseFirestore _fb = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  List<dynamic> typeList = [];
  List<String> stringList = [];
  List menuList = [];
  waitFuncs() async {
    await getTypes();
    await getMenus();
    setState(() {});
  }

  getTypes() async {
    await _fb
        .collection("services")
        .doc("services")
        .collection("mah")
        .doc("types")
        .get()
        .then((value) {
      typeList = value.data()!["types"];
    });
    stringList = typeList.map((e) => e.toString()).toList();
  }

  getMenus() async {
    var data = await _fb
        .collection("services")
        .doc("services")
        .collection("mah")
        .get();
    menuList = data.docs;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waitFuncs();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          if (user!.email == "mah@gmail.com")
            IconButton(
                onPressed: () {
                  List<dynamic> typeList = [];
                  Get.to(() => AddItem(
                        typeList: stringList,
                      ));
                },
                icon: Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                width: size.width * 0.4,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: Image.asset("assets/image/mah.png")),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Хишиг махны дэлгүүр",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text("Утас: 010-0000-0000")
                ],
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: stringList.length,
                itemBuilder: (BuildContext context, int index) => Menu(
                      type: stringList[index],
                      itemList: menuList,
                    )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.shopping_basket),
        onPressed: () {
          Get.to(() => CartProducts());
        },
      ),
    );
  }
}

class Menu extends StatefulWidget {
  Menu({Key? key, required this.type, required this.itemList})
      : super(key: key);
  String type;
  List itemList;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Items item = Items();
  List<dynamic> menuList = [];
  waitFuncs() async {
    await getItems();
    setState(() {});
  }

  getItems() async {
    var data = await FirebaseFirestore.instance
        .collection("services")
        .doc("services")
        .collection("mah")
        .where("type", isEqualTo: widget.type)
        .get()
        .then((value) {
      menuList = value.docs;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waitFuncs();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type != "Төрөл..." && menuList.isNotEmpty) {
      return Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 0, 0, 0), width: 1),
              borderRadius: BorderRadius.circular(29),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ColumnBuilder(
                    itemBuilder: (BuildContext context, int index) => MenuItem(
                          item: menuList[index],
                        ),
                    itemCount: menuList.length)),
          ),
          Positioned(
              left: 50,
              top: 12,
              child: Container(
                padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                color: Colors.white,
                child: Text(widget.type),
              )),
        ],
      );
    } else {
      return Container();
    }
  }
}

class MenuItem extends StatefulWidget {
  DocumentSnapshot item;
  MenuItem({Key? key, required this.item}) : super(key: key);

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  User? user = FirebaseAuth.instance.currentUser;

  final cartController = Get.put(CartController());
  int amount = 1;

  deleteItem() async {
    await FirebaseFirestore.instance
        .collection('services')
        .doc("services")
        .collection("mah")
        .doc(widget.item.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    int price = int.parse(widget.item['price']);

    Product product = Product(
        name: widget.item['name'], price: price, type: widget.item['type']);
    return GestureDetector(
      onTap: () async {
        String imageURL = await Storage().downloadURL(widget.item['name']);
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return SimpleDialog(
                  children: [
                    Image.network(
                      imageURL,
                      width: 160,
                      height: 160,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [Text(product.name), Text("₮$price")],
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Ширхэг: "),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    if (amount > 1) {
                                      setState(() {
                                        amount--;
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.remove_circle)),
                              Text("$amount"),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      amount++;
                                    });
                                  },
                                  icon: Icon(Icons.add_circle)),
                            ],
                          ),
                        ],
                      )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text(
                            "Сагсанд хийх",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            cartController.addAmount(product, amount);
                          },
                        ),
                        if (user!.email == "mah@gmail.com")
                          TextButton(
                            child: Text(
                              "Устгах",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              await deleteItem();
                              Get.back();
                            },
                          ),
                      ],
                    )
                  ],
                );
              },
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(widget.item['name']), Text("₮$price")],
        ),
      ),
    );
  }
}
