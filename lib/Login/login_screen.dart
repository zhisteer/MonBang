import 'package:flutter/material.dart';
import 'package:monbang/constants.dart';
import 'package:monbang/main.dart';
import '../Home/home_screen.dart';
import 'components/logo_hero.dart';
import 'components/utils.dart';
import 'register_screen.dart';

import 'components/d_button.dart';
import 'components/d_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey3 = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(children: [
        Center(
          child: Form(
            key: _formKey3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LogoHero(
                  width: 0.5,
                ),
                const SizedBox(
                  height: 30,
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
                  hintText: "Нууц үг",
                  icon: Icons.lock,
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Нууц үгээ оруулна уу");
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Dbutton(
                  onPressed: () {
                    signIn(emailController.text, passwordController.text);
                  },
                  text: "Нэвтрэх",
                  width: 0.2,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: Text("Бүртгүүлэх")),
                    SizedBox(
                      width: 10,
                    ),
                    Text("forgor pass")
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future signIn(String emailController, String passwordController) async {
    showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (_) => Center(
              child: CircularProgressIndicator(),
            ));

    if (_formKey3.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController, password: passwordController);
      } on FirebaseAuthException catch (e) {
        print(e);
      }
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(seconds: 2),
              pageBuilder: (_, __, ___) => const HomeScreen()),
          (route) => false);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
