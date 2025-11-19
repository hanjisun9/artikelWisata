import 'package:artikel_wisata/screens/auth/login_screen.dart';
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
      home: const SplashScreen(),
    );
  }
}
