import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monbang/Home/Pages/Ads/add_ad.dart';

import 'search_ad.dart';

class PostorSearch extends StatelessWidget {
  const PostorSearch({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            onTap: () {
              Get.to(() => AddAd());
            },
            title: Text("$title нэмэх"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () {
              Get.to(() => SearchJob());
            },
            title: Text("$title хайх"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
    );
  }
}
