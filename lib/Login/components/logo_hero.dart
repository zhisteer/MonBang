import 'package:flutter/material.dart';

class LogoHero extends StatelessWidget {
  final width;
  LogoHero({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return IconButton(
      iconSize: size.width * width,
      onPressed: () {},
      icon: Hero(
        tag: 'logo',
        child: Image.asset("assets/image/monbang.png"),
      ),
    );
  }
}
