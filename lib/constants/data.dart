import 'package:clock_app/constants/constants.dart';
import 'package:clock_app/model/alarm_info_model.dart';
import 'package:clock_app/model/menu_info_model.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.clock, title: "Clock", imageSource: "assets/clock_icon.png"),
  MenuInfo(MenuType.alarm, title: "Alarm", imageSource: "assets/alarm_icon.png"),
  MenuInfo(MenuType.timer, title: "Timer", imageSource: "assets/timer_icon.png"),
  MenuInfo(MenuType.stopwatch, title: "Stopwatch", imageSource: "assets/stopwatch_icon.png"),
];

List<AlarmInfo> alarms = [
  AlarmInfo(id: 1, title: "Office", alarmDateTime: DateTime.now().add(Duration(hours: 1)), isPending: false, gradientColorIndex: GradientColors.sky),
  AlarmInfo(id: 2, title: "Office", alarmDateTime: DateTime.now().add(Duration(hours: 1)), isPending: false, gradientColorIndex: GradientColors.sunset),
  // AlarmInfo(DateTime.now().add(Duration(hours: 1)), description: "Office", gradientColors: GradientColors.sunset),
];