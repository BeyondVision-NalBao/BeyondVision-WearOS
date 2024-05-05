import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:watch_app/page/exercise_page.dart';
import 'package:watch_app/page/homepage.dart';
import 'package:watch_app/provider/alarm_provider.dart';
import 'package:alarm/alarm.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.activityRecognition.request();
  await Alarm.init(showDebugLogs: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _watch = WatchConnectivity();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // _watch.messageStream.listen((e) {
    //   if (e['data'] == 'exercise') {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => const ExercisePage()),
    //     );
    //   }
    // });

    //initPlatformState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _watch.messageStream.listen((e) {
          print(e);
          if (e['data'] == 'phone') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExercisePage()),
            );
          }
        });
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AlarmProvider()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'BeyondVision',
            theme: ThemeData.dark(useMaterial3: true),
            home: const HomePage()));
  }
}
