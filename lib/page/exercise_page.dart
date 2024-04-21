import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watch_app/constants.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.watch_later_outlined,
                  color: Color(fontYellowColor), size: 32),
              Text("  --:--",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, color: Color(fontYellowColor), size: 32),
              Text("  147",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_fire_department,
                  color: Color(fontYellowColor), size: 32),
              Text("  125",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    ));
  }
}
