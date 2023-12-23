import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_with_api/api/api_list_restaurants.dart';
import 'package:restaurant_with_api/model/list_restaurants.dart';
import 'package:restaurant_with_api/page/page_cari_list_restaurants.dart';
import 'package:restaurant_with_api/page/page_detail_restaurants.dart';
import 'package:restaurant_with_api/page/page_list_restaurant.dart';
import 'package:restaurant_with_api/provider/connectionprovider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          RestaurantsProvider(apiListRestaurants: ApiListRestaurants()),
      child: MaterialApp(
        title: 'Restaurants Apps',
        debugShowCheckedModeBanner: false,
        initialRoute: PageListRestaurants.routeName,
        routes: {
          PageListRestaurants.routeName: (context) => PageListRestaurants(),
          PageDetailRestaurants.routeName: (context) => PageDetailRestaurants(
              restaurants:
                  ModalRoute.of(context)?.settings.arguments as Restaurants),
          PageCariListRestaurants.routeName: (context) =>
              PageCariListRestaurants()
        },
      ),
    );
  }
}
