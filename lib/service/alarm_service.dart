import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AlarmService {
  Future<List<List<String>>> getAlarmDate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getString("days") != null && pref.getStringList("time") != null) {
      // List<String> days = pref.getStringList("days")!;
      // List<String> time = pref.getStringList("time")!;
      return [
        ["화", "목", "금"],
        ["9", "15"]
      ];
      //return [days, time];
    }
    return [];
  }

  Future<void> saveAlarmDate(List<String> day, DateTime time) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> formattedTime = [time.hour.toString(), time.minute.toString()];
    //String formattedTime = DateFormat('yyyy-mm-dd').format(time);
    pref.setStringList("days", day);
    pref.setStringList("time", formattedTime);
    //pref.setString("time", formattedTime);
  }
}
