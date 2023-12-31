import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_with_api/prefs/shared_schedule.dart';

import '../component/custom_dialog.dart';
import '../provider/provider_scheduling.dart';

class PageSettings extends StatelessWidget {
  static String routeName = '/page_settings';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurants Settings"),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: ListTile(
            title: const Text('Scheduling News'),
            trailing: Consumer<SchedulingProvider>(
              builder: (context, scheduled, _) {
                return Switch.adaptive(
                  value: scheduled.isScheduled,
                  onChanged: (value) async {
                    if (Platform.isIOS) {
                      customDialog(context);
                    } else {
                      await SharedSchedule.saveSchedule("schedule", value);
                      await scheduled.scheduledNews(value);
                    }
                  },
                );
              },
            ),
          ),
        ),
        // ElevatedButton(
        //     onPressed: () async {
        //       final NotificationHelper notificationHelper =
        //           NotificationHelper();
        //       var result = await ApiListRestaurants().fetctDataRestaurant();
        //       print("callbak berjalan");
        //       await notificationHelper.showNotification(
        //           flutterLocalNotificationsPlugin, result);
        //     },
        //     child: Text("Trigger Notif"))
      ],
    );
  }
}
