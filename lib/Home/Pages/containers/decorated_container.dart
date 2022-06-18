import 'package:flutter/material.dart';
import 'package:monbang/constants.dart';

class DecoratedContainer2 extends StatelessWidget {
  final Widget child;
  final Widget topLeftText;
  const DecoratedContainer2({
    Key? key,
    required this.child,
    required this.topLeftText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: size.height * 0.12,
          margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 0, 0, 0), width: 1),
            borderRadius: BorderRadius.circular(29),
            shape: BoxShape.rectangle,
          ),
          child: child,
        ),
        Positioned(
            left: 50,
            top: 12,
            child: Container(
              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              color: Colors.white,
              child: topLeftText,
            )),
      ],
    );
  }
}
