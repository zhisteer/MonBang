import 'package:flutter/material.dart';
import 'package:monbang/Login/components/d_container.dart';
import 'package:monbang/constants.dart';

class DecoratedField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  bool? obscureText;
  DecoratedField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.validator,
    this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
        child: TextFormField(
      textInputAction: TextInputAction.next,
      controller: controller,
      validator: validator,
      obscureText: obscureText == null ? false : obscureText!,
      decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            icon,
            color: kPrimaryColorAccent,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Color.fromARGB(255, 101, 101, 101))),
    ));
  }
}
