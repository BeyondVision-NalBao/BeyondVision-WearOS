import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watch_app/constants.dart';
import 'package:watch_app/page/widget/main_button.dart';
import 'package:wearable_rotary/wearable_rotary.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StreamSubscription<RotaryEvent> rotarySubscription;
  PageController controller = PageController();
  List<String> content = ["운동\n하기", "즐겨\n찾기", "알람\n설정"];
  @override
  int currentIdx = 0;
  @override
  void initState() {
    // TODO: implement initState
    rotarySubscription = rotaryEvents.listen(handleRotaryEvent);
    super.initState();
  }

  void handleRotaryEvent(RotaryEvent event) {
    if (event.direction == RotaryDirection.clockwise) {
      if (currentIdx < 2) {
        controller.nextPage(
            duration: const Duration(seconds: 1), curve: Curves.easeOutExpo);
      }
    } else if (event.direction == RotaryDirection.counterClockwise) {
      if (currentIdx > 0) {
        controller.previousPage(
            duration: const Duration(seconds: 1), curve: Curves.easeOutExpo);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    rotarySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
      controller: controller,
      itemBuilder: (context, index) {
        return Container(
          child: MainButton(
            name: content[index],
          ),
        );
      },
      itemCount: 3,
      onPageChanged: (page) {
        setState(() {
          currentIdx = page;
        });
      },
    ));
  }
}
