import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monbang/Home/home_screen.dart';
import 'package:monbang/Login/components/d_button.dart';
import 'package:monbang/Login/components/d_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';
import 'components/users.dart';
import 'components/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pass1Controller = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DecoratedField(
                hintText: "Нэр",
                icon: Icons.person,
                controller: nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Нэрээ оруулна уу");
                  }
                },
              ),
              DecoratedField(
                hintText: "E-Mail",
                icon: Icons.email,
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("E-Mail хаягаа оруулна уу");
                  }
                  String pattern = r'\w+@\w+\.\w+';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(emailController.text))
                    return 'E-Mail буруу байна.';
                },
              ),
              DecoratedField(
                hintText: "Нууц Үг",
                icon: Icons.lock,
                controller: pass1Controller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Нууц үгээ оруулна уу");
                  }
                  String pattern =
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(pass1Controller.text)) {
                    return '''
      Password must be at least 8 characters,
      include an uppercase letter, number and symbol.
      ''';
                  }
                },
              ),
              DecoratedField(
                hintText: "Дахиад нууц үг",
                icon: Icons.lock,
                controller: pass2Controller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Нууц үгээ дахиад оруулна уу");
                  }
                  if (value != pass1Controller.text) {
                    return ("Нууц үг адилхан биш байна");
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: Get.back, icon: Icon(Icons.arrow_back)),
                    Dbutton(
                      text: "Бүртгүүлэх",
                      width: 0.3,
                      onPressed: () {
                        signUp(emailController.text, pass1Controller.text);
                      },
                    ),
                  ],
                ),
              )
            ]),
      ),
    ));
  }

  Future signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: email,
              password: password,
            )
            .then((value) => {postDetailsToFirestore()});
      } on FirebaseAuthException catch (e) {
        print(e);
      }
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    Users users = Users();

    users.email = user!.email;
    users.uid = user.uid;
    users.name = nameController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.email)
        .set(users.toMap());
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }
}
