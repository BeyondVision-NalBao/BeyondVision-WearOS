import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watch_app/constants.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';

import 'package:workout/workout.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import 'package:wear/wear.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final _watch = WatchConnectivity();

  var _count = 0;

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

  final workout = Workout();

  //final exerciseType = ExerciseType.walking;
  final features = [
    WorkoutFeature.heartRate,
    WorkoutFeature.calories,
  ];

  double heartRate = 0;
  double calories = 0;
  bool started = false;
  final exerciseType = ExerciseType.plank;

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

  _ExercisePageState() {
    workout.stream.listen((event) {
      // ignore: avoid_print
      print('${event.feature}: ${event.value} (${event.timestamp})');
      switch (event.feature) {
        case WorkoutFeature.unknown:
          return;
        case WorkoutFeature.heartRate:
          setState(() {
            heartRate = event.value;
          });
          break;
        case WorkoutFeature.calories:
          setState(() {
            calories = event.value;
          });
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _watch.messageStream.listen((e) => setState(() {
          _log.add('Received message: $e');
          print(e);
          if (e['data'] == "start") {
            print("tlwkr");
            setState(() {
              isRunning = true;
              started = true;
            });
            toggleExerciseState();
            timer = Timer.periodic(const Duration(seconds: 1), onTick);
          }
          if (e['data'] == "stop") {
            print("뭐냐");
            sendMessage();
            setState(() {
              isRunning = false;
              started = false;
            });
            toggleExerciseState();
            print(started);
          }
          if (e['data'] == 'phone') {
            print('background');
          }
        }));

    _watch.contextStream
        .listen((e) => setState(() => _log.add('Received context: $e')));

    //initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // void initPlatformState() async {
  //   _supported = await _watch.isSupported;
  //   _paired = await _watch.isPaired;
  //   _reachable = await _watch.isReachable;
  //   _context = await _watch.applicationContext;
  //   _receivedContexts = await _watch.receivedApplicationContexts;
  //   setState(() {});
  // }

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
                        Text('$heartRate',
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
    final message = {
      'data':
          '[{time: $totalSeconds}, {heartRate: $heartRate}, {calories: ${calories.toStringAsFixed(2)}}]'
    };
    _watch.sendMessage(message);
    setState(() => _log.add('Sent message: $message'));
  }

  void sendContext() {
    _count++;
    final context = {'data': _count};
    _watch.updateApplicationContext(context);
    setState(() => _log.add('Sent context: $context'));
  }

  void toggleBackgroundMessaging() {
    setState(() {});
  }

  void toggleExerciseState() async {
    if (started) {
      final supportedExerciseTypes = await workout.getSupportedExerciseTypes();
      // ignore: avoid_print
      print('Supported exercise types: ${supportedExerciseTypes.length}');

      final result = await workout.start(
        // In a real application, check the supported exercise types first
        exerciseType: exerciseType,
        features: features,
        enableGps: false,
      );

      if (result.unsupportedFeatures.isNotEmpty) {
        // ignore: avoid_print
        print('Unsupported features: ${result.unsupportedFeatures}');
        // In a real application, update the UI to match
      } else {
        // ignore: avoid_print
        print('All requested features supported');
      }
    } else {
      print("dho");
      await workout.stop();
      heartRate = 0;
      calories = 0;
    }
  }
}
