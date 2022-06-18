import 'package:flutter/material.dart';
import 'package:monbang/constants.dart';

class Dbutton extends StatelessWidget {
  void Function() onPressed;
  final String text;
  final width;
  Dbutton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(
            color: kPrimaryColorAccent,
            borderRadius: BorderRadius.circular(29)),
        width: size.width * width,
        height: size.height * 0.05,
        child: TextButton(
            style: TextButton.styleFrom(
              primary: Color.fromARGB(255, 255, 255, 255),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            onPressed: onPressed,
            child: Center(child: Text(text))));
  }
}
