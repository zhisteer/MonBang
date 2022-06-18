import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InsideAd extends StatelessWidget {
  InsideAd({Key? key, required this.map}) : super(key: key);
  DocumentSnapshot map;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {},
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 223, 223, 223),
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(
                    Icons.person_outline,
                    size: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nuutsaa"),
                      Text(
                        "06/11 11:03",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: SizedBox(
                width: size.width - 30,
                child: Text(
                  map["title"],
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                width: size.width - 30,
                child: Text(
                  map["content"],
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(Icons.male),
                      Text("Хүйс: "),
                      Text(map['gender'])
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.house_outlined),
                      Text("Байр: "),
                      Text(map['housing'])
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month),
                      Text("Ажиллах хугацаа: "),
                      Text(map['term'])
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_city),
                      Text("Хот: "),
                      Text(map['city'])
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.attach_money),
                      Text("Цалин: "),
                      Text(map["wage"])
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.phone_outlined),
                      Text("Утасны дугаар: "),
                      Text("01056094446")
                    ],
                  ),
                ),
              ],
            )
          ]),
        ));
  }
}
