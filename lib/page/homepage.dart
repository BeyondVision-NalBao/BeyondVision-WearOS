import 'dart:async';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:watch_app/page/alarm/alarm_ringing.dart';
import 'package:watch_app/page/widget/main_button.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:wearable_rotary/wearable_rotary.dart';
import 'package:alarm/alarm.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StreamSubscription<RotaryEvent> rotarySubscription;
  PageController controller = PageController();
  List<String> content = ["운동\n하기", "알람\n설정"];

  final _watch = WatchConnectivity();

  int currentIdx = 0;

  static StreamSubscription<AlarmSettings>? subscription;
  @override
  void initState() {
    // TODO: implement initState

    rotarySubscription = rotaryEvents.listen(handleRotaryEvent);
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
    super.initState();
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted.',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  void loadAlarms() {
    setState(() {
      Alarm.getAlarms();
      //alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
      ),
    );
  }

  void handleRotaryEvent(RotaryEvent event) {
    if (event.direction == RotaryDirection.clockwise) {
      if (currentIdx < 1) {
        controller.nextPage(
            duration: const Duration(seconds: 1), curve: Curves.easeOutExpo);
      }
    } else if (event.direction == RotaryDirection.counterClockwise) {
      if (currentIdx > 0) {
        controller.previousPage(
            duration: const Duration(seconds: 1), curve: Curves.easeOutExpo);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    rotarySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: PageView.builder(
      controller: controller,
      itemBuilder: (context, index) {
        return Container(
          child: MainButton(
            name: content[index],
          ),
        );
      },
      itemCount: 3,
      onPageChanged: (page) {
        setState(() {
          currentIdx = page;
        });
      },
    )));
  }
}
