import 'dart:ui';
import 'dart:isolate';
import 'package:restaurant_with_api/api/api_list_restaurants.dart';
import 'package:restaurant_with_api/component/notification_helper.dart';

import '../main.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print("Alarm Ready!!!!");
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiListRestaurants().fetctDataRestaurant();
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
