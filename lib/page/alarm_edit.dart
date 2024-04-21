import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:watch_app/constants.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:watch_app/model/days.dart';
import 'package:watch_app/page/alarm_page.dart';
import 'package:watch_app/page/widget/selected.dart';

class AlarmEdit extends StatefulWidget {
  const AlarmEdit({super.key});

  @override
  State<AlarmEdit> createState() => _AlarmEditState();
}

class _AlarmEditState extends State<AlarmEdit> {
  @override
  Widget build(BuildContext context) {
    List<Widget> editPage = [editDate(), editTime()];

    return Scaffold(
        body: PageView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return Center(child: editPage[index]);
      },
    ));
  }

  Widget editDate() {
    List<Days> days = [
      Days(1, "월", false),
      Days(2, "화", false),
      Days(3, "수", false),
      Days(4, "목", false),
      Days(5, "금", false),
      Days(6, "토", false),
      Days(7, "일", true)
    ];

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.7,
            child: GridView.count(
              crossAxisCount: 4,
              children: List.generate(7, (index) {
                return SelectImage(
                    index: index,
                    name: days[index].day,
                    isSelected: days[index].select,
                    onTap: (index) {
                      setState(() {
                        print(days[index].select);
                        days[index].select = !days[index].select;

                        print(days[index].select);
                      });
                    });
              }),
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(boxColor)),
              onPressed: () {},
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
