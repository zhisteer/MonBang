import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          Get.to(() => ShoppingCart());
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

class MenuItem extends StatelessWidget {
  DocumentSnapshot item;
  MenuItem({Key? key, required this.item}) : super(key: key);
  TextEditingController amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int price = int.parse(item['price']);
    return GestureDetector(
      onTap: () async {
        String imageURL = await Storage().downloadURL(item['name']);
        showDialog(
            context: context,
            builder: (BuildContext context) => SimpleDialog(
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
                        children: [Text(item['name']), Text("₮$price")],
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Ширхэг: "),
                          Container(width: 50, child: TextField())
                        ],
                      )),
                    ),
                    TextButton(
                      child: Text(
                        "Сагсанд хийх",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {},
                    )
                  ],
                ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(item['name']), Text("₮$price")],
        ),
      ),
    );
  }
}
