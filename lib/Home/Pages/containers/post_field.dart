import 'package:flutter/material.dart';
import 'package:monbang/Home/Pages/containers/post_field_container.dart';
import 'package:monbang/constants.dart';

class PostField extends StatelessWidget {
  final String hintText;
  final height;
  final onChanged;

  final TextEditingController controller;
  final String? Function(String?)? validator;
  PostField(
      {Key? key,
      required this.hintText,
      required this.controller,
      required this.validator,
      this.height,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostFieldContainer(
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: Color.fromARGB(105, 0, 0, 0))),
        onChanged: onChanged,
      ),
      height: height,
    );
  }
}
