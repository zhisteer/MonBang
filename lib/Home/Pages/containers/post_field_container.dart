import 'package:flutter/material.dart';
import 'package:monbang/constants.dart';

class PostFieldContainer extends StatelessWidget {
  final Widget child;
  final height;
  const PostFieldContainer({
    Key? key,
    required this.child,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: size.width * 1,
        height: size.height * height,
        decoration:
            BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))),
        child: child);
  }
}
