import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_with_api/component/background_service.dart';

import '../component/date_time.dart';
import '../prefs/shared_schedule.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  SchedulingProvider() {
    _initSchedule();
  }

  Future<void> _initSchedule() async {
    _isScheduled = await SharedSchedule.getSchedule("schedule");
    notifyListeners(); // Update listeners
  }

  Future<bool> scheduledNews(bool value) async {
    // final bool getboll = await SharedSchedule.getSchedule("schedule");
    _isScheduled = value;
    notifyListeners();

    if (_isScheduled) {
      print('Scheduling News Activated');
      notifyListeners();

      print("Jam Notifikasi : ${DateTimeHelper.format().toString()}");
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling News Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }

  @pragma('vm:entry-point')
  static void printHello() {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  }
}
