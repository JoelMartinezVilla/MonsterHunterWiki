// lib/main.dart
import 'package:flutter/material.dart';
import 'MobileHomeScreen.dart';
import 'DesktopHomeScreen.dart';

void main() {
  runApp(MonsterHunterApp());
}

class MonsterHunterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monster Hunter App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ResponsiveHomeScreen(),
    );
  }
}

class ResponsiveHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width <= 600) {
      return MobileHomeScreen();
    } else {
      return DesktopHomeScreen();
    }
  }
}
