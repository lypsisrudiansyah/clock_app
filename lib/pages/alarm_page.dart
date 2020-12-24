import 'package:clock_app/constants/constants.dart';
import 'package:clock_app/helpers/alarm_helper.dart';
import 'package:clock_app/helpers/ui/modal_helper.dart';
import 'package:clock_app/main.dart';
import 'package:clock_app/model/alarm_info_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime _alarmTime;
  String _alarmTimeString;
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>> _alarms;

  @override
  void initState() {
    // TODO: implement initState
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print("database initialized");
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
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
            child: FutureBuilder<List<AlarmInfo>>(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data.map<Widget>((alarm) {
                      var alarmTime =
                          DateFormat('hh:mm aa').format(alarm.alarmDateTime);
                      var gradientColor = GradientTemplate
                          .gradientTemplate[alarm.gradientColorIndex].colors;
                      return Container(
                        margin: EdgeInsets.only(bottom: 32),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColor,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradientColor.last.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 4,
                              offset: Offset(4, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
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
                                SizedBox(width: 8),
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
                                  alarmTime,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Avenir",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.white,
                                  onPressed: () {
                                    ModalHelper.instance.modalKeluar(
                                      context,
                                      modalTitle:
                                          "Are you sure want to delete this alarm ?",
                                      onClick: () {
                                        Navigator.maybePop(context);
                                        _alarmHelper.delete(alarm.id);
                                        loadAlarms();
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }).followedBy([
                      if (snapshot.data.length < 5)
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              onPressed: () {
                                _alarmTimeString =
                                    DateFormat('HH:mm').format(DateTime.now());
                                // scheduleAlarm();
                                showModalBottomSheet(
                                    useRootNavigator: true,
                                    context: context,
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24))),
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setModalState) {
                                          return Container(
                                            padding: EdgeInsets.all(32),
                                            child: Column(
                                              children: [
                                                FlatButton(
                                                  onPressed: () async {
                                                    var selectedTime =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                    );
                                                    if (selectedTime != null) {
                                                      final now =
                                                          DateTime.now();
                                                      var selectedeDateTime =
                                                          DateTime(
                                                              now.year,
                                                              now.month,
                                                              now.day,
                                                              selectedTime.hour,
                                                              selectedTime
                                                                  .minute);
                                                      _alarmTime =
                                                          selectedeDateTime;
                                                      setModalState(() {
                                                        _alarmTimeString =
                                                            selectedTime
                                                                .toString();
                                                      });
                                                    }
                                                  },
                                                  child: Text(
                                                    _alarmTimeString,
                                                    style:
                                                        TextStyle(fontSize: 32),
                                                  ),
                                                ),
                                                ListTile(
                                                  title: Text('Repeat'),
                                                  trailing: Icon(
                                                      Icons.arrow_forward_ios),
                                                ),
                                                ListTile(
                                                  title: Text('Sound'),
                                                  trailing: Icon(
                                                      Icons.arrow_forward_ios),
                                                ),
                                                ListTile(
                                                  title: Text('Title'),
                                                  trailing: Icon(
                                                      Icons.arrow_forward_ios),
                                                ),
                                                FloatingActionButton.extended(
                                                    onPressed: () async {
                                                      DateTime
                                                          scheduleAlarmDateTime;
                                                      if (_alarmTime.isAfter(
                                                          DateTime.now())) {
                                                        scheduleAlarmDateTime =
                                                            _alarmTime;
                                                      } else {
                                                        scheduleAlarmDateTime =
                                                            _alarmTime.add(
                                                                Duration(
                                                                    days: 1));
                                                      }
                                                      scheduleAlarm(
                                                          scheduleAlarmDateTime);
                                                      var alarmInfo = AlarmInfo(
                                                          alarmDateTime:
                                                              scheduleAlarmDateTime,
                                                          gradientColorIndex:
                                                              snapshot
                                                                  .data.length,
                                                          title: "alarm");
                                                      _alarmHelper.insertAlarm(
                                                          alarmInfo);
                                                      Navigator.maybePop(
                                                          context);
                                                      loadAlarms();
                                                    },
                                                    icon: Icon(Icons.alarm),
                                                    label: Text('Save'))
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    });
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
                  );
                }

                return Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void scheduleAlarm(scheduleAlarmDateTime) async {
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    var time = tz.TZDateTime.from(
      scheduleAlarmDateTime,
      tz.local,
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "alarm_notif",
      "alarm_notif",
      "Channel for alarm notification",
      icon: 'learn_more',
      priority: Priority.high,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('alarm1'),
      largeIcon: DrawableResourceAndroidBitmap('learn_more'),
      fullScreenIntent: true,
      styleInformation: BigTextStyleInformation(''),
      timeoutAfter: 2500,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      sound: 'alarm1.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // await flutterLocalNotificationsPlugin.show(
    //     0,
    //     "Office",
    //     "Good Afternoon, and Good Upgrade, Learn More, Learn More Learn More Learn More Learn MoreLearn More",
    //     platformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Bismillah",
        "Semangat terus belajarnya, jangan buang waktu ya rudi, ingat ada orang tua yang kita mesti berbakti kepada keduanya, ingat kelak ada ukhti yang harus dinikahi",
        time,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}
