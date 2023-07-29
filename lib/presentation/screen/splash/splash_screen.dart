import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';

import '../product/product_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // splash screen yang dibangun menggunakan dependencies another flutter splash screen
      body: FlutterSplashScreen.fadeIn(
        backgroundColor: Colors.greenAccent,
        onInit: () {
          debugPrint("On Init");
        },
        onEnd: () {
          debugPrint("On End");
        },
        onAnimationEnd: () => debugPrint("On Fade In End"),
        defaultNextScreen: const ListProduct(),
        childWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: Image.asset("assets/logo/burger.png"),
            ),
            const Text(
              "My Food",
              style: TextStyle(color: Colors.white, fontSize: 40),
            )
          ],
        ),
      ),
    );
  }
}
