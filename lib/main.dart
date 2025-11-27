import 'package:artikel_wisata/screens/articles/detail_screen.dart';
import 'package:artikel_wisata/screens/auth/edit_profile_screen.dart';
import 'package:artikel_wisata/screens/auth/profile_screen.dart';
import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jelajah Nusantara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: SplashScreen(),
    );
  }
}
