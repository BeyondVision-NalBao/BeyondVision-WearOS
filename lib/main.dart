import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_app/page/homepage.dart';
import 'package:watch_app/provider/alarm_provider.dart';
import 'package:alarm/alarm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(showDebugLogs: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          home: const HomePage(),
        ));
  }
}
