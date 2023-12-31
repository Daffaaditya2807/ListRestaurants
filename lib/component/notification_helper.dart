import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_with_api/model/list_restaurants.dart';
import 'package:restaurant_with_api/page/page_detail_restaurants.dart';
import 'package:restaurant_with_api/provider/provider_list_restaurants.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;
  int? randomIndex;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
      final payload = details.payload;
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      ListRestaurants restaurants) async {
    var channelId = "1";
    var channelName = "channel_01";
    var channelDescription = "dicoding news channel";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    randomIndex = Random().nextInt(restaurants.restaurants.length);
    var titleNotification =
        "<b>${restaurants.restaurants[randomIndex!].name}</b>";

    var titleNews = restaurants.restaurants[randomIndex!].desc;
    print("random Index euy ${randomIndex}");

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleNews, platformChannelSpecifics,
        payload: json.encode(restaurants.toJson()));
  }

  void configureSelectNotificationSubject(BuildContext context) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        print("random Index euy22 ${randomIndex}");
        var data = ListRestaurants.fromJson(json.decode(payload));
        var restaurants = data.restaurants[randomIndex!];

        var result = await PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: PageDetailRestaurants(restaurants: restaurants),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );

        String checkResult = result.toString();
        if (checkResult == 'true' || checkResult == 'null') {
          Provider.of<RestaurantsProvider>(context, listen: false)
              .getAllRestaurantsdb();
          Provider.of<RestaurantsProvider>(context, listen: false)
              .loadFavorite();
        }
      },
    );
  }
}
