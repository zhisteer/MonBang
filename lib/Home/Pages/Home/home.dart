import 'package:flutter/material.dart';
import 'package:monbang/Home/Pages/Home/board.dart';
import 'package:monbang/Home/Pages/Home/faq.dart';
import 'package:monbang/Home/Pages/containers/decorated_container.dart';
import 'package:monbang/Login/components/d_button.dart';
import 'package:monbang/Login/components/d_container.dart';

import '../../../Login/components/logo_hero.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            DecoratedContainer2(
              child: Center(
                  child: Dbutton(
                width: 0.2,
                text: "Орох",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FreeBoard()),
                  );
                },
              )),
              topLeftText: Text(
                "Чөлөөт Самбар",
                style: TextStyle(fontSize: 18),
              ),
            ),
            DecoratedContainer2(
              child: Center(
                  child: Dbutton(
                width: 0.2,
                text: "Орох",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FAQ()),
                  );
                },
              )),
              topLeftText: Text(
                "Түгээмэл Асуултууд",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
