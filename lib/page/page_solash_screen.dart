import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_with_api/page/page_bottom_bar.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splashscreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nextPages();
  }

  void _nextPages() async {
    Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.pushReplacementNamed(context, PageBottomBar.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Lottie.asset("assets/restaurant_animated.json",
              width: 200, height: 200, fit: BoxFit.fill),
        ),
      ),
    );
  }
}
