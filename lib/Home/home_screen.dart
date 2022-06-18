import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monbang/Home/Pages/chatter.dart';
import 'package:monbang/constants.dart';

import '../Login/components/logo_hero.dart';
import 'Pages/Ads/ads.dart';
import 'Pages/Home/home.dart';
import 'Pages/Services/services.dart';
import 'Pages/Settings/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final screens = [
    HomePage(),
    ServicesPage(),
    AdsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.message),
                onPressed: () {
                  Get.to(() => Chatters());
                },
                color: Colors.black,
              ),
              LogoHero(width: 0.1),
            ],
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Үйлчилгээ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Зар',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Тохиргоо',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Color.fromARGB(120, 255, 255, 255),
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
