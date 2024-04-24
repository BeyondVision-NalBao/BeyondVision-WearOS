import 'package:flutter/material.dart';
feimport 'package:provider/provider.dart';
import 'package:watch_app/page/homepage.dart';
import 'package:watch_app/provider/alarm_provider.dart';

void main() {
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
          title: 'The Flutter Way',
          theme: ThemeData.dark(useMaterial3: true),
          home: const HomePage(),
        ));
  }
}
