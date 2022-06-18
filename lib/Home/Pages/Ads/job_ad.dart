import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_ad.dart';

class JobAd {
  String gender;
  String city;
  String term;
  String housing;
  String title;
  String content;
  JobAd(
      {required this.city,
      required this.gender,
      required this.housing,
      required this.term,
      required this.content,
      required this.title});
  JobAd.fromSnapshot(DocumentSnapshot snapshot)
      : gender = snapshot['gender'],
        housing = snapshot['housing'],
        term = snapshot['term'],
        content = snapshot['content'],
        city = snapshot['city'],
        title = snapshot['title'];
}
