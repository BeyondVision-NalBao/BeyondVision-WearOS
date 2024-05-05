import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watch_app/constants.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:wear/wear.dart';
import 'dart:convert';
import 'package:heart_rate_flutter/heart_rate_flutter.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final _watch = WatchConnectivity();

  // var _supported = false;
  // var _paired = false;
  // var _reachable = false;
  // var _context = <String, dynamic>{};
  // var _receivedContexts = <Map<String, dynamic>>[];
  final _log = <String>[];
  final isWear = true;

  Timer? timer;

  int totalSeconds = 0;
  bool isRunning = false;

  var _supported = false;
  var _paired = false;
  var _reachable = false;

  int weight = 70;
  final HeartRateFlutter heartRate = HeartRateFlutter();
  var heartBeatValue = 0;

  //final exerciseType = ExerciseType.walking;

  double calories = 0.0;
  bool started = false;
  String name = "";
  void onTick(Timer timer) {
    if (isRunning == true) {
      setState(() {
        totalSeconds = totalSeconds + 1;
        calculateCalories();
      });
    } else {
      setState(
        () {
          totalSeconds = 0;
        },
      );

      timer.cancel();
    }
  }

  calculateCalories() {
    name = "스쿼트";
    if (name == '스쿼트') {
      calories = 3.5 * 3.5 * weight * totalSeconds / 12000;
    } else if (name == '레터럴레이즈') {
      calories = 2.5 * 3.5 * weight * totalSeconds / 12000;
    } else if (name == '숄더프레스') {
      calories = 4 * 3.5 * weight * totalSeconds / 12000;
    } else if (name == '헌드레드') {
      calories = 3.5 * 3.5 * weight * totalSeconds / 12000;
    } else if (name == '플랭크') {
      calories = 2.5 * 3.5 * weight * totalSeconds / 12000;
    } else if (name == '프론트레이즈') {
      calories = 2.5 * 3.5 * weight * totalSeconds / 12000;
    } else if (name == '제트업') {
      calories = 3 * 3.5 * weight * totalSeconds / 12000;
    } else if (name == '브릿지') {
      calories = 2.5 * 3.5 * weight * totalSeconds / 12000;
    } else if (name == '상체 - 어꺠') {
      calories = 1.7 * 3.5 * weight * totalSeconds / 12000;
    } else if (name == '상체 - 옆구리') {
      calories = 1.7 * 3.5 * weight * totalSeconds / 12000;
    } else if (name == '하체 - 허벅지') {
      calories = 1.7 * 3.5 * weight * totalSeconds / 12000;
    }
  }

  @override
  void initState() {
    super.initState();

    //initPlatformState();
    heartRate.init();
    heartRate.heartBeatStream.listen((double event) {
      if (mounted) {
        setState(() {
          heartBeatValue = event.toInt();
        });
      }
    });
    _watch.messageStream.listen((e) => setState(() {
          if (e['data'] == "stop") {
            sendMessage();
            setState(() {
              isRunning = false;
              started = false;
            });
          } else {
            print("e");
            //몸무게를 보내자
            //운동 타입 세팅
            List<dynamic> parsedJson = jsonDecode(e['data']);
            name = parsedJson[0]['exercise'];
            weight = parsedJson[0]['weight'];
            setState(() {
              isRunning = true;
              started = true;
            });
            timer = Timer.periodic(const Duration(seconds: 1), onTick);
          }
        }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (timer != null) {
      timer!.cancel();
    }

    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initPlatformState() async {
    _supported = await _watch.isSupported;
    _paired = await _watch.isPaired;
    _reachable = await _watch.isReachable;
    print(_reachable);
    setState(() {});
  }

  String format(int seconds) {
    var duration =
        Duration(seconds: seconds).toString().split(".").first.substring(2, 7);
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    final home = Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text('Supported: $_supported'),
                // Text('Paired: $_paired'),
                // Text('Reachable: $_reachable'),
                // Text('Context: $_context'),
                // Text('Received contexts: $_receivedContexts'),
                // TextButton(
                //   onPressed: initPlatformState,
                //   child: const Text('Refresh'),
                // ),
                // const SizedBox(height: 8),
                // const Text('Send'),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     TextButton(
                //       onPressed: sendMessage,
                //       child: const Text('Message'),
                //     ),
                //     const SizedBox(width: 8),
                //     // TextButton(
                //     //   onPressed: sendContext,
                //     //   child: const Text('Context'),
                //     // ),
                //   ],
                // ),
                // TextButton(
                //   onPressed: toggleBackgroundMessaging,
                //   child: Text(
                //     '${timer == null ? 'Start' : 'Stop'} background messaging',
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // const SizedBox(width: 16),
                // TextButton(
                //   onPressed: _watch.startWatchApp,
                //   child: const Text('Start watch app'),
                // ),
                // const SizedBox(width: 16),
                // const Text('Log'),
                // ..._log.reversed.map(Text.new),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(Icons.watch_later_outlined,
                            color: Color(fontYellowColor), size: 32),
                        Text(format(totalSeconds),
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(Icons.favorite,
                            color: Color(fontYellowColor), size: 32),
                        Text(heartBeatValue.toString(),
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: Color(fontYellowColor), size: 32),
                        Text(calories.toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return MaterialApp(
        home: AmbientMode(
      builder: (context, mode, child) => child!,
      child: home,
    ));
  }

  void sendMessage() {
    String jsonData = jsonEncode([
      {
        'time': totalSeconds,
        'heartRate': heartBeatValue,
        'calories': double.parse(calories.toStringAsFixed(2))
      }
    ]);
    final message = {'data': jsonData};

    _watch.sendMessage(message);
  }
}
