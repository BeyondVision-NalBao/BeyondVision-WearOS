import 'package:flutter/material.dart';

class Days with ChangeNotifier {
  final int id;
  final String day;
  bool select;

  Days(this.id, this.day, this.select);

  bool get selectedPref => select;

  void selected() {
    select = !select;
  }
}
