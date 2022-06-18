import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monbang/Home/Pages/Ads/post_or_search.dart';

import '../../../Login/components/logo_hero.dart';

class AdsPage extends StatelessWidget {
  AdsPage({Key? key}) : super(key: key);
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('Ads')
              .doc('ad')
              .collection('adlist')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic>? map = snapshot.data!.docs[index].data()
                      as Map<String, dynamic>?;
                  return Zar(
                    map: map,
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class Zar extends StatelessWidget {
  Map<String, dynamic>? map;
  Zar({
    Key? key,
    required this.map,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(map!['name'], style: TextStyle(fontSize: 20)),
        onTap: () {
          Get.to(() => PostorSearch(
                title: map!['name'],
              ));
        },
        onLongPress: () {},
        dense: false,
        trailing: const SizedBox(
            height: double.infinity, child: Icon(Icons.keyboard_arrow_right)),
        minVerticalPadding: 35,
      ),
    );
  }
}
