import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monbang/Home/Pages/Services/mah.dart';
import 'package:monbang/Home/Pages/Services/menu_item.dart';
import 'package:monbang/Home/Pages/Services/storage_services.dart';

class AddItem extends StatefulWidget {
  List<String> typeList;

  AddItem({Key? key, required this.typeList}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String typeValue = "Төрөл...";
  File? image;
  final Storage storage = Storage();
  var path;
  var fileName;

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      path = image.path;

      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      Get.snackbar("Алдаа", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () {
                  addThisItem();
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                child: TextField(
                  style: TextStyle(fontSize: 20),
                  controller: nameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Нэр...",
                      hintStyle: TextStyle(fontSize: 20)),
                ),
              ),
              Container(
                child: TextField(
                  style: TextStyle(fontSize: 20),
                  controller: priceController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Үнэ...(₮12500)",
                      hintStyle: TextStyle(fontSize: 20)),
                ),
              ),
              Row(
                children: [
                  DropdownButton<String>(
                    value: typeValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    onChanged: (String? newValue) {
                      setState(() {
                        typeValue = newValue!;
                      });
                    },
                    items: widget.typeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              TextButton(
                child: Text("Зураг сонгох"),
                onPressed: () async {
                  await getImage();
                },
              ),
              image != null
                  ? Image.file(
                      image!,
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ],
          ),
        ));
  }

  addThisItem() async {
    Items item = Items();
    item.name = nameController.text;
    item.price = priceController.text;
    item.type = typeValue;
    fileName = item.name;
    await FirebaseFirestore.instance
        .collection("services")
        .doc("services")
        .collection("mah")
        .add(item.toMap());
    try {
      storage.uploadFile(path, fileName).then(
            (value) => print("done"),
          );
    } on FirebaseException catch (e) {
      Get.snackbar("Алдаа", e.toString());
    }
    Get.off(() => MahScreen());
  }
}
