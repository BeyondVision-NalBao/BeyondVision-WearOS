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

  Future<void> setDays(List<List<String>> pref) async {
    AlarmService alarm = AlarmService();
    DateTime now = DateTime.now();

    if (pref.isNotEmpty) {
      for (var day in days) {
        if (pref[0].contains(day.day) == true) {
          day.select = true;
        }
      }

      time = DateTime(now.year, now.month, now.day, int.parse(pref[1][0]),
          int.parse(pref[1][1]));

      print(time);
    }
  }
}
