import 'package:clock_app/constants/constants.dart';
import 'package:clock_app/constants/data.dart';
import 'package:clock_app/helpers/alarm_helper.dart';
import 'package:clock_app/main.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime _alarmTime;
  String _alarmTimeString;
  AlarmHelper _alarmHelper = AlarmHelper();

  @override
  void initState() {
    // TODO: implement initState
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print("database initialized");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Alarm",
            style: TextStyle(
                fontFamily: 'Avenir',
                fontWeight: FontWeight.w700,
                color: CustomColors.primaryTextColor,
                fontSize: 24),
          ),
          Expanded(
            child: ListView(
              children: alarms.map<Widget>((alarm) {
                _alarmTimeString =
                    DateFormat("hh:mm aa").format(alarm.alarmDateTime);
                return Container(
                  margin: EdgeInsets.only(bottom: 32),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: alarm.gradientColorIndex,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: alarm.gradientColorIndex.last.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 4,
                          offset: Offset(4, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.label,
                            color: Colors.white,
                            size: 24,
                          ),
                          Text(
                            "Office",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Avenir",
                            ),
                          ),
                          Switch(
                            value: true,
                            onChanged: (bool value) {},
                            activeColor: Colors.white,
                          )
                        ],
                      ),
                      Text(
                        "Mon-Fri",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Avenir",
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _alarmTimeString,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Avenir",
                                fontWeight: FontWeight.w700,
                                fontSize: 24),
                          ),
                          Icon(Icons.keyboard_arrow_down,
                              size: 36, color: Colors.white)
                        ],
                      ),
                    ],
                  ),
                );
              }).followedBy([
                DottedBorder(
                  strokeWidth: 2,
                  color: CustomColors.clockOutline,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(24),
                  dashPattern: [5, 4],
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: CustomColors.clockBG,
                      borderRadius: BorderRadius.all(
                        Radius.circular(24),
                      ),
                    ),
                    child: FlatButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      onPressed: () {
                        scheduleAlarm();
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/add_alarm.png",
                            scale: 1.5,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Add Alarm",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Avenir",
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ]).toList(),
            ),
          )
        ],
      ),
    );
  }

  void scheduleAlarm() async {
    var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "alarm_notif",
      "alarm_notif",
      "Channel for alarm notification",
      icon: 'learn_more',
      priority: Priority.high,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('sound_2'),
      largeIcon: DrawableResourceAndroidBitmap('learn_more'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      sound: 'sound_2.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(0, "Office", "Good Afternoon, and Good Upgrade, Learn More, Learn More Learn More Learn More Learn MoreLearn More", platformChannelSpecifics);
    // await flutterLocalNotificationsPlugin.schedule(0, "Office", "Good Afternoon, and Good Upgrade, Learn More", scheduledNotificationDateTime, platformChannelSpecifics);
  }
}
