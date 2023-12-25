import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_with_api/api/api_list_restaurants.dart';
import 'package:restaurant_with_api/api/api_search_list_restaurants.dart';
import 'package:restaurant_with_api/model/list_restaurants.dart';
import 'package:restaurant_with_api/page/page_cari_list_restaurants.dart';
import 'package:restaurant_with_api/page/page_detail_restaurants.dart';
import 'package:restaurant_with_api/page/page_list_restaurant.dart';
import 'package:restaurant_with_api/page/page_solash_screen.dart';
import 'package:restaurant_with_api/provider/connectionprovider.dart';

import 'api/api_detail_restaurants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantsProvider(apiListRestaurants: ApiListRestaurants()),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailRestaurantProvider(
            apiDetailRestaurants: ApiDetailRestaurants(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CariRestaurantsProvider(
              apiSearchListRestaurants: ApiSearchListRestaurants()),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewsAddProviders(),
        )
      ],
      child: MaterialApp(
        title: 'Restaurants Apps',
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => SplashScreen(),
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
