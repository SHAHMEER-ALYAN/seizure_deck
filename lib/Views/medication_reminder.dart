import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seizure_deck/services/notification_services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import '/services/AlarmSetupPage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:platform/platform.dart';

enum MedicineType { Syrup, Tablets, Syringe }

class medicationReminder extends StatefulWidget {
  const medicationReminder({super.key});

  @override
  _medicationReminderWidgetState createState() =>
      _medicationReminderWidgetState();
}

class _medicationReminderWidgetState extends State<medicationReminder> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<String> reminderOptions = [
    'Everyday',
    'Every X Days',
    'Days of Week',
    'Any',
  ];

  String selectedOption = 'Everyday';
  var label = 'Notification';
  bool isSyrupSelected = false;
  bool isTabletSelected = false;
  bool isSyringeSelected = false;

  MedicineType selectedMedicine = MedicineType.Syrup; 

  String getHintText() {
    switch (selectedMedicine) {
      case MedicineType.Syrup:
        return 'Enter dosage in ml/mg for syrup';
      case MedicineType.Tablets:
        return 'Enter number of tablets';
      case MedicineType.Syringe:
        return 'Enter syringe dosage in ml';
    }
  }

  Future<void> _scheduleNotification(DateTime scheduledTime) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    tz.initializeTimeZones();
    var scheduledTimeZone = tz.local;
    var scheduledDateTime = tz.TZDateTime.from(
      scheduledTime,
      scheduledTimeZone,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, 
      'Reminder', 
      "It's time to take your medicine!", 
      scheduledDateTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  TextEditingController textController = TextEditingController();
  final TextEditingController medicineController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  DateTime? datePicked1;
  DateTime? datePicked2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Medication'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Medication Name',
                      style: TextStyle(
                        color: Color(0xFF454587),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: medicineController, 
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                width: 2, color: Color(0xFF454587))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                width: 2, color: Color(0xFF454587))),
                        hintText: ("Enter Medicine"),
                      ),
                    ),
                  ],
                ),
              ),

              
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Frequency',
                      style: TextStyle(
                        color: Color(0xFF454587),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedOption,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue!;
                        });
                      },
                      items: reminderOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Medicine Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF454587),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                MdiIcons.medication,
                                color: selectedMedicine == MedicineType.Syrup
                                    ? Colors.purple
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedMedicine = MedicineType.Syrup;
                                  dosageController.clear();
                                });
                              },
                              iconSize: 30, 
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Syrup",
                              style: TextStyle(
                                color: selectedMedicine == MedicineType.Syrup
                                    ? Colors.purple
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                MdiIcons.pill,
                                color: selectedMedicine == MedicineType.Tablets
                                    ? Colors.purple
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedMedicine = MedicineType.Tablets;
                                  dosageController.clear();
                                });
                              },
                              iconSize: 30, 
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Tablets",
                              style: TextStyle(
                                color: selectedMedicine == MedicineType.Tablets
                                    ? Colors.purple
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                MdiIcons.needle,
                                color: selectedMedicine == MedicineType.Syringe
                                    ? Colors.purple
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedMedicine = MedicineType.Syringe;
                                  dosageController.clear();
                                });
                              },
                              iconSize: 30, 
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Syringe",
                              style: TextStyle(
                                color: selectedMedicine == MedicineType.Syringe
                                    ? Colors.purple
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dosage',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFF454587),
                            ),
                          ),
                          TextField(
                            controller: dosageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: getHintText(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Color(0xFF454587),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() {
                            datePicked1 = date;
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF454587),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15.0), 
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15.0), 
                            side: const BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                      child: const Text(
                        "Select Date",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          final now = DateTime.now();
                          final scheduledDateTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          await _scheduleNotification(scheduledDateTime);
                        }
                        if (selectedTime != null) {
                          setState(() {
                            datePicked2 = DateTime(
                              datePicked2!.year,
                              datePicked2!.month,
                              datePicked2!.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF454587),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15.0), 
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15.0), 
                          side: const BorderSide(
                              width: 2,
                              color:
                                  Color.fromARGB(255, 255, 255, 255)), 
                        ),
                      ),
                      child: const Text(
                        "Select Time",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ToggleSwitch(
                      minWidth: 100.0,
                      minHeight: 36.0,
                      initialLabelIndex: 0,
                      activeBgColor: const [Color(0xFF454587)],
                      labels: const ['Notification', 'Alarm'],
                      onToggle: (index) {
                        setState(() {
                          if (index == 0) {
                            ElevatedButton(
                              child: const Text('Set Notification'),
                              onPressed: () {
                                if (datePicked1 != null) {
                                  
                                  final currentTime = DateTime.now();
                                  if (datePicked1!.isAfter(currentTime)) {
                                    
                                    String formattedDate =
                                        DateFormat('dd/MM/yy')
                                            .format(datePicked1!);
                                    String formattedTime = DateFormat('HH:mm')
                                        .format(datePicked2!);
                                    NotificationService().showNotification(
                                      title: 'Notification',
                                      body:
                                          'Your Notification has been set for $formattedDate at $formattedTime',
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Invalid Date'),
                                          content: const Text(
                                              'Please select a future Date and Time to set a Notification!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Date Not Selected'),
                                        content: const Text(
                                            'Please select a Date and Time to set a Notification.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AlarmSetupPage(),
                              ),
                            );
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final alarmSettings = AlarmSettings(
                          id: 42,
                          dateTime: datePicked1!,
                          assetAudioPath: 'assets/alarm.mp3',
                          loopAudio: true,
                          vibrate: true,
                          volume: 0.8,
                          fadeDuration: 3.0,
                          notificationTitle: 'Alarm for ${medicineController.text}',
                          notificationBody: 'Dosage is ${dosageController.text}',
                          enableNotificationOnKill: true,
                        );
                        await Alarm.set(alarmSettings: alarmSettings);
                        Navigator.pop(context);
                        Future.delayed(Duration(seconds: 15)).then((value) => Alarm.stop(42));
                        // Alarm.stop(42);


                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
