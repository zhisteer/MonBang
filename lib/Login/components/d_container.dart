import 'package:flutter/material.dart';
import 'package:monbang/constants.dart';

class DecoratedContainer extends StatelessWidget {
  final Widget child;
  const DecoratedContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: size.width * 0.7,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(29),
            border: Border.all(color: Color.fromARGB(255, 0, 0, 0))),
        child: child);
  }
}
