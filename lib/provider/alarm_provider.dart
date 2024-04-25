import 'package:flutter/material.dart';
import 'package:watch_app/model/days.dart';
import 'package:watch_app/service/alarm_service.dart';

class AlarmProvider with ChangeNotifier {
  DateTime time = DateTime.now();
  List<Days> days = [
    Days(0, "월", false),
    Days(1, "화", false),
    Days(2, "수", false),
    Days(3, "목", false),
    Days(4, "금", false),
    Days(5, "토", false),
    Days(6, "일", false)
  ];
  int flag = 0;

  Future<void> setDays(List<List<String>> pref) async {
    DateTime now = DateTime.now();

    if (pref.isNotEmpty && flag == 0) {
      for (int i = 0; i < 7; i++) {
        if (pref[0].contains(days[i].day) == true) {
          days[i].select = true;
          //selectedDay[i].select = false;
        }
      }

      time = DateTime(now.year, now.month, now.day, int.parse(pref[1][0]),
          int.parse(pref[1][1]));

      flag = 1;
    } else {}
  }

  Future<DateTime> getNextAlarm() async {
    AlarmService alarm = AlarmService();
    List<List<String>> pref = await alarm.getAlarmDate();
    DateTime now = DateTime.now();
    DateTime next = DateTime.now();
    int day = now.weekday - 1;
    int nextWeek = 0;
    for (int i = 0; i < 7; i++) {
      if (pref[0].contains(days[i].day) == true) {
        days[i].select = true;
      }
    }
    for (int i = day + 1; i < 7; i++) {
      if (days[i].select == true) {
        next = now.add(Duration(days: i - day + nextWeek));
        break;
      } else {
        if (i == 6) {
          i = 0;
          nextWeek = 7;
        }
        continue;
      }
    }

    time = DateTime(next.year, next.month, next.day, int.parse(pref[1][0]),
        int.parse(pref[1][1]));

    return time;
  }
}
