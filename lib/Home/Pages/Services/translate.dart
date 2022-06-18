import 'package:flutter/material.dart';

class InsideService extends StatelessWidget {
  const InsideService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Орчуулга", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(12)),
              child: const Icon(
                Icons.person,
                size: 70,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Орчуулагч: Translator"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Туршлага: "),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
