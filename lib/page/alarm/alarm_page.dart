import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_app/constants.dart';
import 'package:watch_app/model/days.dart';
import 'package:watch_app/page/alarm/alarm_edit.dart';
import 'package:watch_app/provider/alarm_provider.dart';
import 'package:watch_app/service/alarm_service.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    AlarmService alarm = AlarmService();
    AlarmProvider alarmProvider = Provider.of<AlarmProvider>(context);
    void deleteAlarm() {
      Alarm.stop(1);
    }

    String makeString(List<Days> days) {
      String result = "";
      int count = 0;

      for (var day in days) {
        if (day.select == true) {
          result += day.day;
          count++;
          if (count == 3) {
            result += ",\n";
          } else {
            result += ", ";
          }
        }
      }

      if (count == 7) {
        return "매일";
      }

      return result.substring(0, result.length - 2);
    }

    String makeTime(DateTime time) {
      String hour = time.hour.toString();
      String min = time.minute.toString();
      return "$hour:$min";
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Center(
            child: FutureBuilder(
                future: alarm.getAlarmDate(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    alarmProvider.setDays(snapshot.data!);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(makeString(alarmProvider.days),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color(fontYellowColor),
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        Text(makeTime(alarmProvider.time),
                            style: const TextStyle(
                                color: Color(fontYellowColor),
                                fontSize: 36,
                                fontWeight: FontWeight.bold)),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(boxColor)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AlarmEdit()));
                            },
                            child: const Text("변경",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(boxColor)),
                            onPressed: deleteAlarm,
                            child: const Text("삭제",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)))
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Container(child: const Text("아직 설정된 알람이 없습니다.")),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(boxColor)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AlarmEdit()));
                            },
                            child: const Text("변경",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))),
                      ],
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
