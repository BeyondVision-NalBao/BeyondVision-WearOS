import 'package:flutter/material.dart';
import 'package:watch_app/constants.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:watch_app/model/days.dart';
import 'package:watch_app/page/alarm_page.dart';
import 'package:watch_app/page/widget/selected.dart';
import 'package:wearable_rotary/wearable_rotary.dart';
import 'dart:async';

class AlarmEdit extends StatefulWidget {
  const AlarmEdit({super.key});

  @override
  State<AlarmEdit> createState() => _AlarmEditState();
}

class _AlarmEditState extends State<AlarmEdit> {
  List<Days> days = [
    Days(0, "월", false),
    Days(1, "화", false),
    Days(2, "수", false),
    Days(3, "목", false),
    Days(4, "금", false),
    Days(5, "토", false),
    Days(6, "일", false)
  ];

  late final StreamSubscription<RotaryEvent> rotarySubscription;
  PageController controller = PageController();
  @override
  void initState() {
    // TODO: implement initState
    rotarySubscription = rotaryEvents.listen(handleRotaryEvent);
    super.initState();
  }

  void handleRotaryEvent(RotaryEvent event) {
    if (event.direction == RotaryDirection.clockwise) {
    } else if (event.direction == RotaryDirection.counterClockwise) {}
  }

  @override
  void dispose() {
    // TODO: implement dispose
    rotarySubscription.cancel();
    super.dispose();
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
                        name: days[index].day,
                        isSelected: days[index].select,
                        onTap: (index) {
                          setState(() {
                            days[index].selected();
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
    DateTime dateTime = DateTime.now();
    return Column(
      children: [
        SizedBox(
          height: 130,
          child: TimePickerSpinner(
            highlightedTextStyle: const TextStyle(
                color: Color(fontYellowColor),
                fontSize: 36,
                fontWeight: FontWeight.bold),
            normalTextStyle: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            minutesInterval: 15,
            onTimeChange: (time) {
              setState(() {
                dateTime = time;
              });
            },
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(boxColor)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AlarmPage()));
            },
            child: const Text("완료",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)))
      ],
    );
  }
}
