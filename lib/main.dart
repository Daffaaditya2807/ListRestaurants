import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_with_api/api/api_list_restaurants.dart';
import 'package:restaurant_with_api/api/api_search_list_restaurants.dart';
import 'package:restaurant_with_api/component/navigation.dart';
import 'package:restaurant_with_api/model/list_restaurants.dart';
import 'package:restaurant_with_api/page/page_bottom_bar.dart';
import 'package:restaurant_with_api/page/page_cari_list_restaurants.dart';
import 'package:restaurant_with_api/page/page_detail_restaurants.dart';
import 'package:restaurant_with_api/page/page_list_favorite_restaurants.dart';
import 'package:restaurant_with_api/page/page_list_restaurant.dart';
import 'package:restaurant_with_api/page/page_settings.dart';
import 'package:restaurant_with_api/page/page_solash_screen.dart';
import 'package:restaurant_with_api/provider/provider_detail_restaurants.dart';
import 'package:restaurant_with_api/provider/provider_list_restaurants.dart';
import 'package:restaurant_with_api/provider/provider_scheduling.dart';

import 'api/api_detail_restaurants.dart';
import 'component/background_service.dart';
import 'component/notification_helper.dart';
import 'provider/provider_addreviews_restaurants.dart';
import 'provider/provider_search_restaurants.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

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
        ),
        ChangeNotifierProvider(
          create: (context) => SchedulingProvider(),
          child: PageSettings(),
        )
      ],
      child: MaterialApp(
        title: 'Restaurants Apps',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => SplashScreen(),
          PageListRestaurants.routeName: (context) => PageListRestaurants(),
          PageDetailRestaurants.routeName: (context) => PageDetailRestaurants(
              restaurants:
                  ModalRoute.of(context)?.settings.arguments as Restaurants),
          PageCariListRestaurants.routeName: (context) =>
              PageCariListRestaurants(),
          PageListFaveRestaurants.routeName: (context) =>
              PageListFaveRestaurants(),
          PageSettings.routeName: (context) => PageSettings(),
          PageBottomBar.routeName: (context) => PageBottomBar()
        },
      ),
    );
  }
}
