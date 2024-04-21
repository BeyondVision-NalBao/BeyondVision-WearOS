import 'package:flutter/material.dart';
import 'package:watch_app/constants.dart';
import 'package:watch_app/page/alarm_edit.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("화, 수, 목",
                style: TextStyle(
                    color: Color(fontYellowColor),
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const Text("15:00",
                style: TextStyle(
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
                        fontWeight: FontWeight.bold)))
          ],
        ),
      ),
    );
  }
}
