import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heart_rate_flutter/heart_rate_flutter_platform_interface.dart';
import 'package:watch_app/constants.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:workout/workout.dart';
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

  HeartRateFlutter heartRate = HeartRateFlutter();
  var heartBeatValue = 0;

  void _listener() {
    heartRate.heartBeatStream.listen((double event) {
      if (mounted) {
        setState(() {
          heartBeatValue = event.toInt();
        });
      }
    });
  }

  //final exerciseType = ExerciseType.walking;

  double calories = 0;
  bool started = false;
  String name = "";
  void onTick(Timer timer) {
    if (isRunning == true) {
      setState(() {
        totalSeconds = totalSeconds + 1;
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
    if (name == '스쿼트') {
      calories = totalSeconds * 0.11 * 70;
    } else if (name == '레터럴레이즈') {
      calories = totalSeconds * 0.7 * 70;
    } else if (name == '숄더프레스') {
      calories = totalSeconds * 0.10 * 70;
    } else if (name == '헌드레드') {
      calories = totalSeconds * 0.18 * 70;
    } else if (name == '플랭크') {
      calories = totalSeconds * 0.09 * 70;
    } else if (name == '프론트레이즈') {
      calories = totalSeconds * 0.07 * 70;
    } else if (name == '제트업') {
      calories = totalSeconds * 0.14 * 70;
    } else if (name == '브릿지') {
      calories = totalSeconds * 0.17 * 70;
    } else if (name == '스트레칭1') {
      calories = totalSeconds * 0.04 * 70;
    } else if (name == '스트레칭2') {
      calories = totalSeconds * 0.04 * 70;
    } else if (name == '스트레칭3') {
      calories = totalSeconds * 0.04 * 70;
    }
  }

  @override
  void initState() {
    super.initState();

    //initPlatformState();
    heartRate.init();
    _listener();
    _watch.messageStream.listen((e) => setState(() {
          if (e['data'] == "stop") {
            sendMessage();
            setState(() {
              isRunning = false;
              started = false;
            });
          } else {
            //몸무게를 보내자
            //운동 타입 세팅
            name = e['data'];
            setState(() {});
            timer = Timer.periodic(const Duration(seconds: 1), onTick);
          }
        }));
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
                TextButton(
                  onPressed: initPlatformState,
                  child: const Text('Refresh'),
                ),
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
        'heartRate': heartRate,
        'calories': double.parse(calories.toStringAsFixed(2))
      }
    ]);
    final message = {'data': jsonData};

    _watch.sendMessage(message);
  }
}
