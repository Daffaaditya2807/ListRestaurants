import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ComponentWidget {
  static Widget NoInternet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("assets/no_internet.json", width: 200, height: 200),
          const Text(
            "No Internet Connection",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Text(
            "Please! check your internet connection then make sure turn on WI-Fi or Data Seluler",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}
