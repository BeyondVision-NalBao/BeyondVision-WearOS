import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:provider/provider.dart';
import 'package:watch_app/constants.dart';
import 'package:watch_app/page/homepage.dart';
import 'package:watch_app/provider/alarm_provider.dart';

class AlarmRingScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const AlarmRingScreen({Key? key, required this.alarmSettings})
      : super(key: key);

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  bool loading = false;
  void setNewAlarm(DateTime selectedDateTime) {
    if (loading) return;
    setState(() => loading = true);
    Alarm.set(alarmSettings: buildAlarmSettings(selectedDateTime)).then((res) {
      if (res) {
        Navigator.pop(context, true);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
      setState(() => loading = false);
    });
  }

  AlarmSettings buildAlarmSettings(DateTime selectedDateTime) {
    final id = DateTime.now().millisecondsSinceEpoch % 10000;

    final alarmSettings = AlarmSettings(
      id: 1,
      dateTime: selectedDateTime,
      loopAudio: false,
      vibrate: true,
      volume: null,
      assetAudioPath: 'assets/marimba.mp3',
      notificationTitle: 'Alarm example',
      notificationBody: 'Your alarm ($id) is ringing',
    );
    return alarmSettings;
  }

  @override
  Widget build(BuildContext context) {
    AlarmProvider alarm = Provider.of<AlarmProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   "운동할\n시간이에요!",
            //   style: TextStyle(
            //       color: Color(fontYellowColor),
            //       fontSize: 36,
            //       fontWeight: FontWeight.bold),
            //   textAlign: TextAlign.center,
            // ),
            Image.asset('assets/Logo.png',
                width: MediaQuery.of(context).size.width * 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(
                  onPressed: () async {
                    setNewAlarm(await alarm.getNextAlarm());
                    Alarm.stop(widget.alarmSettings.id)
                        .then((_) => Navigator.pop(context));
                  },
                  child: const Text(
                    "Stop",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
