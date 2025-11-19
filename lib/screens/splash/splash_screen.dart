import 'dart:async';

import 'package:artikel_wisata/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity1 = 0.0;
  double _opacity2 = 0.0;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity1 = 1.0;
      });
    });

    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _opacity2 = 1.0;
      });
    });

    Timer(const Duration(milliseconds: 2500), () {
      setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFF6F2E5),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipPath(
                clipper: WaveClipperBottom(),
                child: Container(
                  color: Color(0XFFD1A824),
                  height: MediaQuery.of(context).size.height * 3 / 4,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: _opacity1,
                        duration: const Duration(milliseconds: 800),
                        child: const Text(
                          "JELAJAH",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontFamily: "NicoMoji",
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _opacity2,
                        duration: const Duration(milliseconds: 800),
                        child: const Text(
                          "NUSANTARA",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontFamily: "NicoMoji",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: WaveClipperTop(),
              child: Container(
                color: Color(0XFFF6F2E5),
                height: MediaQuery.of(context).size.height * 1 / 4,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WaveClipperBottom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(0, size.height - 80);

    path.quadraticBezierTo(
      size.width * 2 / 5,
      size.height + 20,
      size.width * 2 / 5,
      size.height - 50,
    );

    path.quadraticBezierTo(
      size.width * 2 / 5,
      size.height - 130,
      size.width,
      size.height - 50,
    );

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class WaveClipperTop extends CustomClipper<Path> {
  @override
   Path getClip(Size size) {
    var path = Path();

    path.moveTo(0, size.height - 70);

    path.quadraticBezierTo(
      size.width * 3 / 5,
      size.height + 5,
      size.width * 3 / 5,
      size.height - 50,
    );

    path.quadraticBezierTo(
      size.width * 3 / 5,
      size.height - 120,
      size.width,
      size.height - 50,
    );

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
