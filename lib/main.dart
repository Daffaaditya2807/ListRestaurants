import 'package:flutter/material.dart';
import 'package:restaurant_with_api/model/list_restaurants.dart';
import 'package:restaurant_with_api/page/page_detail_restaurants.dart';
import 'package:restaurant_with_api/page/page_list_restaurant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: PageListRestaurants.routeName,
      routes: {
        PageListRestaurants.routeName: (context) => PageListRestaurants(),
        PageDetailRestaurants.routeName: (context) => PageDetailRestaurants(
            restaurants:
                ModalRoute.of(context)?.settings.arguments as Restaurants),
      },
    );
  }
}
