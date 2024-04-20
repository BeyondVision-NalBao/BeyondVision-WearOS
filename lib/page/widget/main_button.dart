import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watch_app/constants.dart';
import 'package:watch_app/page/widget/circluar_button.dart';

class MainButton extends StatelessWidget {
  final String name;
  const MainButton({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: OutlineCircleButton(
          onTap: () {
            if (name == "운동\n하기") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const WorkOut()));
            } else if (name == "즐겨\n찾기") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const WorkOut()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const WorkOut()));
            }
          },
          child: Center(
            child: Text(name,
                style: const TextStyle(
                    color: Color(fontYellowColor),
                    fontSize: 48,
                    fontWeight: FontWeight.bold)),
          )),
    );
  }
}
