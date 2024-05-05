import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:watch_app/constants.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:watch_app/page/alarm/alarm_page.dart';
import 'package:watch_app/page/widget/selected.dart';
import 'package:watch_app/provider/alarm_provider.dart';
import 'package:watch_app/service/alarm_service.dart';
import 'package:wearable_rotary/wearable_rotary.dart';
import 'package:alarm/alarm.dart';

class AlarmEdit extends StatefulWidget {
  const AlarmEdit({super.key});

  @override
  State<AlarmEdit> createState() => _AlarmEditState();
}

class _AlarmEditState extends State<AlarmEdit> {
  bool loading = false;

  PageController controller = PageController();
  AlarmService alarm = AlarmService();
  @override
  void initState() {
    // TODO: implement initState\

    super.initState();
  }

  void saveAlarm(DateTime selectedDateTime) {
    if (loading) return;
    setState(() => loading = true);
    Alarm.set(alarmSettings: buildAlarmSettings(selectedDateTime)).then((res) {
      if (res) {
        Navigator.pop(context);
      }
      setState(() => loading = false);
    });
  }

  AlarmSettings buildAlarmSettings(DateTime selectedDateTime) {
    final alarmSettings = AlarmSettings(
      id: 1,
      dateTime: selectedDateTime,
      loopAudio: true,
      vibrate: true,
      volume: null,
      assetAudioPath: 'assets/marimba.mp3',
      notificationTitle: 'Alarm example',
      notificationBody: 'Now, it`s exercise Time',
      enableNotificationOnKill: true,
    );
    return alarmSettings;
  }

  @override
  void dispose() {
    super.dispose(); // 상위 클래스의 dispose() 메서드를 호출합니다.
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> editPage = [editDate(), editTime()];

    return Scaffold(
        body: PageView.builder(
      controller: controller,
      itemCount: 2,
      itemBuilder: (context, index) {
        return Center(child: editPage[index]);
      },
    ));
  }

  Widget editDate() {
    AlarmProvider alarmProvider = Provider.of<AlarmProvider>(context);

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                  controller: RotaryScrollController(),
                  //scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (BuildContext context, int index) {
                    return SelectImage(
                        index: index,
                        name: alarmProvider.days[index].day,
                        isSelected: alarmProvider.days[index].select,
                        onTap: (index) {
                          setState(() {
                            alarmProvider.days[index].select =
                                !alarmProvider.days[index].select;
                          });
                        });
                  }),
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(boxColor)),
              onPressed: () {
                controller.nextPage(
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeOutExpo);
              },
              child: const Text("시간 변경",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))
        ]);
  }

  Widget editTime() {
    AlarmProvider alarmProvider = Provider.of<AlarmProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 130,
            child: TimePickerSpinner(
              time: alarmProvider.time,
              highlightedTextStyle: const TextStyle(
                  color: Color(fontYellowColor),
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
              normalTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              minutesInterval: 15,
              onTimeChange: (time) {
                setState(() {
                  alarmProvider.time = time;
                });
              },
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(boxColor)),
              onPressed: () async {
                List<String> selectedDay = [];
                String days = "";
                for (var day in alarmProvider.days) {
                  if (day.select == true) {
                    selectedDay.add(day.day);

                    days += "${day.day}, ";
                  }
                }
                // setState(() {
                //   isSpeaking = true;
                // });
                // if (isSpeaking == true) {
                //   await tts.speak(
                //       "$days 요일 ${alarmProvider.time.hour}시 ${alarmProvider.time.minute}에 울립니다.");
                // }
                // setState(() {
                //   isSpeaking = false;
                //   print(isSpeaking);
                // });

                saveAlarm(alarmProvider.time);
                await alarm.saveAlarmDate(selectedDay, alarmProvider.time);
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AlarmPage()));
              },
              child: const Text("완료",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}
