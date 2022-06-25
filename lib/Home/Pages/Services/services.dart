import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monbang/Home/Pages/Services/mah.dart';
import 'package:monbang/Home/Pages/Services/translate.dart';

import '../../../Login/components/logo_hero.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            crossAxisCount: 2,
            children: <Widget>[
              GridContainer(
                icon: Icons.translate,
                text: Text("Орчуулга"),
                onTap: () {
                  Get.to(() => InsideService());
                },
              ),
              GridContainer(
                icon: Icons.food_bank,
                text: Text(
                  "Мах захиалах",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Get.to(() => MahScreen());
                },
              ),
            ],
          ),
        ));
  }
}

class GridContainer extends StatelessWidget {
  var onTap;
  final Widget text;
  final IconData icon;
  GridContainer({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(29),
            border: Border.all(color: Color.fromARGB(255, 0, 0, 0), width: 1),
            color: Color.fromARGB(255, 255, 255, 255)),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 70,
            ),
            text,
          ],
        )),
      ),
    );
  }
}
