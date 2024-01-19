import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seizure_deck/services/notification_services.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import '/services/AlarmSetupPage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum MedicineType { Syrup, Tablets, Syringe }

class medicationReminder extends StatefulWidget {
  const medicationReminder({Key? key}) : super(key: key);

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

  MedicineType selectedMedicine = MedicineType.Syrup; // Default medicine type

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

    // Convert the DateTime object to a TZDateTime
    var scheduledDateTime = tz.TZDateTime.from(
      scheduledTime,
      scheduledTimeZone,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Reminder', // Title
      "It's time to take your medicine!", // Body
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
        AndroidInitializationSettings('@mipmap/ic_launcher');
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
        title: Text('Add New Medication'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Medication Name input field
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
                      controller: medicineController, // Add the controller here
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

              // Dropdown for Frequency Reminder Options
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
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedOption,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
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

              // IconButtons
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
                    SizedBox(height: 10),
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
                              iconSize: 30, // Set the icon size
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
                              iconSize: 30, // Set the icon size
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
                              iconSize: 30, // Set the icon size
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
                    // Dosage Text Field
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
                                borderSide: BorderSide(
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

              // Select Date Button
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
                        backgroundColor: Color(0xFF454587),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15.0), // Padding
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15.0), // Button shape
                            side: BorderSide(
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

                    // Select Time Button
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
                        backgroundColor: Color(0xFF454587),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15.0), // Padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15.0), // Button shape
                          side: BorderSide(
                              width: 2,
                              color:
                                  Color.fromARGB(255, 255, 255, 255)), // Border
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

              // Toggle Switch for Reminder and Alarm
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ToggleSwitch(
                      minWidth: 100.0,
                      minHeight: 36.0,
                      initialLabelIndex: 0,
                      activeBgColor: [Color(0xFF454587)],
                      labels: ['Notification', 'Alarm'],
                      onToggle: (index) {
                        setState(() {
                          if (index == 0) {
                            // Notification is selected
                            ElevatedButton(
                              child: const Text('Set Notification'),
                              onPressed: () {
                                if (datePicked1 != null) {
                                  // Compare the selected date with the current date and time
                                  final currentTime = DateTime.now();
                                  if (datePicked1!.isAfter(currentTime)) {
                                    // Format the date and time
                                    String formattedDate =
                                        DateFormat('dd/MM/yy')
                                            .format(datePicked1!);
                                    String formattedTime = DateFormat('HH:mm')
                                        .format(datePicked2!);

                                    // The selected date is in the future, so set the notification
                                    NotificationService().showNotification(
                                      title: 'Notification',
                                      body:
                                          'Your Notification has been set for $formattedDate at $formattedTime',
                                    );
                                  } else {
                                    // The selected date is in the past, show an error message
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
                                  // Handle the case where the date & time is not selected
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
                            // Alarm is selected
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

              // Save Button
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // For Validation if clicked on Save button then Error or Next Page will Navigate
                        // if (medicineController.text.isEmpty ||
                        //     dosageController.text.isEmpty ||
                        //     datePicked1 == null ||
                        //     datePicked2 == null ||
                        //     selectedMedicine == null ||
                        //     selectedOption.isEmpty) {
                        //   showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return AlertDialog(
                        //         title: const Text('Error'),
                        //         content: const Text('Please fill all the required fields to proceed.'),
                        //         actions: [
                        //           TextButton(
                        //             onPressed: () {
                        //               Navigator.pop(context);
                        //             },
                        //             child: const Text('OK'),
                        //           ),
                        //         ],
                        //       );
                        //     },
                        //   );
                        // } else {
                        //   // Save data logic goes here
                        //   // This section is reached when all required fields are filled
                        //   // Save the data or proceed to the next step
                        //   // For example, navigate to a new page with the collected data:
                        //   // Navigator.push(
                        //   //   context,
                        //   //   MaterialPageRoute(
                        //   //     builder: (context) => GenerateMedication(),
                        //   //   ),
                        //   // );
                        // }
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
