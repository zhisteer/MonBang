import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monbang/Login/components/utils.dart';
import 'package:monbang/Login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Home/home_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        // scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
              bodyColor: Color.fromARGB(255, 0, 0, 0),
              displayColor: Color.fromARGB(255, 0, 0, 0)),
          scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
          appBarTheme:
              AppBarTheme(titleTextStyle: TextStyle(color: Colors.black)),
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('${(snapshot.error.toString())}');
              return Text("error");
            } else if (snapshot.hasData) {
              return StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return HomeScreen();
                    } else {
                      return LoginScreen();
                    }
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
        //const LoginScreen(),
        );
  }
}
