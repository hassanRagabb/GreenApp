// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// enum ReminderInterval { Daily, EveryTwoDays, EveryThreeDays, EverySevenDays }

// class ReminderPage extends StatefulWidget {
//   const ReminderPage({Key? key}) : super(key: key);

//   @override
//   _ReminderPageState createState() => _ReminderPageState();
// }

// class _ReminderPageState extends State<ReminderPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _timeController = TextEditingController();
//   final TextEditingController _messageController = TextEditingController();
//   ReminderInterval _selectedInterval = ReminderInterval.Daily;
//   List<Map<String, dynamic>> reminders = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadReminders();
//   }

//   @override
//   void dispose() {
//     _timeController.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadReminders() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.email)
//           .collection('reminders')
//           .get()
//           .then((QuerySnapshot querySnapshot) {
//         List<Map<String, dynamic>> fetchedReminders = [];
//         for (var document in querySnapshot.docs) {
//           Map<String, dynamic> data =
//               document.data() as Map<String, dynamic>? ?? {};
//           Map<String, dynamic> reminderData = {
//             'id': document.id,
//             ...data,
//           };
//           fetchedReminders.add(reminderData);
//         }
//         setState(() {
//           reminders = fetchedReminders;
//         });
//       }).catchError((error) {
//         print('Failed to fetch reminders: $error');
//       });
//     }
//   }

//   Future<void> _addReminder() async {
//     if (_formKey.currentState != null && _formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       TimeOfDay selectedTime = TimeOfDay.fromDateTime(
//         DateFormat.jm().parse(_timeController.text),
//       );
//       String message = _messageController.text;

//       Map<String, dynamic> newReminder = {
//         'time': selectedTime.format(context),
//         'reminderText': message,
//         'interval': _selectedInterval.toString(),
//       };

//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.email)
//             .collection('reminders')
//             .add(newReminder)
//             .then((value) {
//           print('Reminder added successfully!');
//           _clearForm();
//           _loadReminders(); // Reload reminders after adding a new one
//         }).catchError((error) {
//           print('Failed to add reminder: $error');
//         });
//       }
//     }
//   }

//   Future<void> _deleteReminder(int index) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.email)
//           .collection('reminders')
//           .doc(reminders[index]['id'])
//           .delete()
//           .then((value) {
//         print('Reminder deleted successfully!');
//         setState(() {
//           reminders.removeAt(index);
//         });
//       }).catchError((error) {
//         print('Failed to delete reminder: $error');
//       });
//     }
//   }

//   void _clearForm() {
//     _timeController.clear();
//     _messageController.clear();
//     _selectedInterval = ReminderInterval.Daily;
//   }

//   String getIntervalLabel(ReminderInterval interval) {
//     switch (interval) {
//       case ReminderInterval.Daily:
//         return 'Daily';
//       case ReminderInterval.EveryTwoDays:
//         return 'Every 2 Days';
//       case ReminderInterval.EveryThreeDays:
//         return 'Every 3 Days';
//       case ReminderInterval.EverySevenDays:
//         return 'Weekly';
//       default:
//         return '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Watering Reminders',
//           style: TextStyle(color: Colors.green, fontSize: 25),
//         ),
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.green),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _messageController,
//                 decoration: const InputDecoration(
//                   labelText: 'Which Plants  🌱',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter Plants';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _timeController,
//                 decoration: const InputDecoration(
//                   labelText: 'Select Time  ⏰',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.green,
//                     ),
//                   ),
//                 ),
//                 readOnly: true,
//                 onTap: () async {
//                   final TimeOfDay? pickedTime = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (pickedTime != null) {
//                     setState(() {
//                       _timeController.text = pickedTime.format(context);
//                     });
//                   }
//                 },
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please select a time';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               DropdownButtonFormField<ReminderInterval>(
//                 value: _selectedInterval,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedInterval = value!;
//                   });
//                 },
//                 items: const [
//                   DropdownMenuItem(
//                     value: ReminderInterval.Daily,
//                     child: Text('Daily'),
//                   ),
//                   DropdownMenuItem(
//                     value: ReminderInterval.EveryTwoDays,
//                     child: Text('Every 2 Days'),
//                   ),
//                   DropdownMenuItem(
//                     value: ReminderInterval.EveryThreeDays,
//                     child: Text('Every 3 Days'),
//                   ),
//                   DropdownMenuItem(
//                     value: ReminderInterval.EverySevenDays,
//                     child: Text('Weekly'),
//                   ),
//                 ],
//                 decoration: const InputDecoration(
//                   labelText: 'Interval',
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: _addReminder,
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.green,
//                 ),
//                 child: const Text('Add Reminder'),
//               ),
//               const SizedBox(height: 16.0),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: reminders.length,
//                   itemBuilder: (context, index) {
//                     final reminder = reminders[index];
//                     final selectedTime = reminder['time'] as String;
//                     final reminderText = reminder['reminderText'] as String;
//                     final interval = reminder['interval'] as String;

//                     final ReminderInterval parsedInterval =
//                         ReminderInterval.values.firstWhere(
//                       (e) => e.toString() == 'ReminderInterval.$interval',
//                       orElse: () => ReminderInterval.Daily,
//                     );

//                     return ListTile(
//                       title: Text('$selectedTime - $reminderText'),
//                       subtitle:
//                           Text('Interval: ${getIntervalLabel(parsedInterval)}'),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () {
//                           _deleteReminder(index);
//                           _loadReminders(); // Reload reminders after deleting one
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';

class SchedulingScreen extends StatefulWidget {
  @override
  _SchedulingScreenState createState() => _SchedulingScreenState();
}

class _SchedulingScreenState extends State<SchedulingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> reminders = [];

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _loadReminders();
  }

  @override
  void dispose() {
    _dateTimeController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadReminders() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentReference<Map<String, dynamic>> userDocRef =
            firestore.collection('users').doc(currentUser.uid);
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await userDocRef.get();

        if (userSnapshot.exists) {
          List<dynamic>? userReminders =
              (userSnapshot.data() as Map<String, dynamic>)['reminders'];
          if (userReminders != null) {
            setState(() {
              reminders = List<Map<String, dynamic>>.from(userReminders);
            });
          }
        }
      }
    } catch (error) {
      print('Failed to load reminders: $error');
    }
  }

  Future<void> _scheduleNotification(
      DateTime selectedDateTime, String message) async {
    FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Replace with your launcher icon path
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notifications.initialize(initializationSettings);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      //'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notifications.zonedSchedule(
      0,
      'Reminder',
      'It\'s time for your scheduled task: $message',
      tz.TZDateTime.from(selectedDateTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _addScheduleToDatabase(
      DateTime selectedDateTime, String reminderText) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentReference<Map<String, dynamic>> userDocRef =
            firestore.collection('users').doc(currentUser.uid);

        // Add the new reminder to the local state
        Map<String, dynamic> newReminder = {
          'dateTime': selectedDateTime.millisecondsSinceEpoch,
          'reminderText': reminderText,
        };
        setState(() {
          reminders.add(newReminder);
        });

        // Update the database
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await userDocRef.get();
        if (userSnapshot.exists) {
          List<dynamic>? userReminders = userSnapshot.data()?['reminders'];
          if (userReminders != null) {
            userReminders.add(newReminder);
          } else {
            userReminders = [newReminder];
          }
          await userDocRef.update({'reminders': userReminders});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Schedule added to the database.')),
          );
        } else {
          await userDocRef.set({
            'reminders': [newReminder]
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('New user document created with schedule.')),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add schedule to the database.')),
      );
    }
  }

  Future<void> _deleteReminder(int index) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentReference<Map<String, dynamic>> userDocRef =
            firestore.collection('users').doc(currentUser.uid);
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await userDocRef.get();

        if (userSnapshot.exists) {
          List<dynamic>? userReminders =
              (userSnapshot.data() as Map<String, dynamic>)['reminders'];
          if (userReminders != null) {
            userReminders.removeAt(index);
            await userDocRef.update({
              'reminders': userReminders,
            });

            setState(() {
              reminders = List<Map<String, dynamic>>.from(userReminders);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Reminder deleted.')),
            );
          }
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete reminder.')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      DateTime selectedDateTime = DateTime.parse(_dateTimeController.text);
      String message = _messageController.text;

      _scheduleNotification(selectedDateTime, message);
      _addScheduleToDatabase(selectedDateTime, message); // Add this line

      // Clear the text fields after adding the schedule
      _dateTimeController.clear();
      _messageController.clear();
    }
  }

  Future<void> _selectDateTime() async {
    DateTime? selectedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (selectedDateTime != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        DateTime selectedDateTimeWithTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        if (selectedDateTimeWithTime.isAfter(DateTime.now())) {
          setState(() {
            _dateTimeController.text = selectedDateTimeWithTime.toString();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a future date and time.')),
          );
        }
      }
    }
  }

  //first (working)
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text(
  //         'Reminder',
  //         style: TextStyle(color: Color.fromARGB(255, 6, 136, 3), fontSize: 25),
  //       ),
  //       backgroundColor: Colors.white,
  //       iconTheme: const IconThemeData(color: Colors.green),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Form(
  //         key: _formKey,
  //         child: Column(
  //           children: [
  //             TextFormField(
  //               controller: _dateTimeController,
  //               decoration: const InputDecoration(labelText: 'Date and Time'),
  //               readOnly: true,
  //               onTap: _selectDateTime,
  //               validator: (value) {
  //                 if (value!.isEmpty) {
  //                   return 'Please select a date and time';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             TextFormField(
  //               controller: _messageController,
  //               decoration:
  //                   const InputDecoration(labelText: 'Reminder Message'),
  //               validator: (value) {
  //                 if (value!.isEmpty) {
  //                   return 'Please enter a reminder message';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             const SizedBox(height: 16.0),
  //             ElevatedButton(
  //               onPressed: _submitForm,
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: const Color.fromARGB(255, 98, 178, 97),
  //               ),
  //               child: const Text(
  //                 'Add Schedule',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   color: Colors.white,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //             const SizedBox(height: 16.0),
  //             const Text(
  //               'Scheduled Reminders',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 8.0),
  //             Expanded(
  //               child: ListView.builder(
  //                 itemCount: reminders.length,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   dynamic dateTimeValue = reminders[index]['dateTime'];
  //                   DateTime dateTime;

  //                   if (dateTimeValue is Timestamp) {
  //                     dateTime = dateTimeValue.toDate();
  //                   } else if (dateTimeValue is int) {
  //                     dateTime =
  //                         DateTime.fromMillisecondsSinceEpoch(dateTimeValue);
  //                   } else {
  //                     // Handle the case where the dateTime field has an unexpected type
  //                     dateTime = DateTime
  //                         .now(); // Default value or any appropriate fallback
  //                   }

  //                   String reminderText = reminders[index]['reminderText'];
  //                   return ListTile(
  //                     title: Text('Reminder: $reminderText'),
  //                     subtitle: Text('Date and Time: $dateTime'),
  //                     trailing: IconButton(
  //                       icon: const Icon(Icons.delete),
  //                       onPressed: () => _deleteReminder(index),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reminder',
          style: TextStyle(color: Color.fromARGB(255, 6, 136, 3), fontSize: 25),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Add a Task  📝',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green), // Set your desired border color
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a reminder message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _dateTimeController,
                decoration: const InputDecoration(
                  labelText: 'Select Date and Time  📅',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green), // Set your desired border color
                  ),
                ),
                readOnly: true,
                onTap: _selectDateTime,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select a date and time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 98, 178, 97),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Add Schedule',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Scheduled Reminders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: reminders.length,
                  itemBuilder: (BuildContext context, int index) {
                    dynamic dateTimeValue = reminders[index]['dateTime'];
                    DateTime dateTime;

                    if (dateTimeValue is Timestamp) {
                      dateTime = dateTimeValue.toDate();
                    } else if (dateTimeValue is int) {
                      dateTime =
                          DateTime.fromMillisecondsSinceEpoch(dateTimeValue);
                    } else {
                      dateTime = DateTime.now();
                    }

                    String reminderText = reminders[index]['reminderText'];
                    String timeString = DateFormat.Hm().format(
                        dateTime); // Format the time as hours and minutes
                    String dateString = DateFormat.MMMd()
                        .format(dateTime); // Format the date as month and day

                    return Card(
                      elevation: 20.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text(
                          '$reminderText',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              'Date: $dateString',
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 69, 138, 63)),
                            ),
                            const SizedBox(
                                width:
                                    20.0), // Add some space between date and time
                            Text(
                              'Time: $timeString',
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 69, 138, 63)),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete,
                              color: Color.fromARGB(255, 233, 113, 113)),
                          onPressed: () => _deleteReminder(index),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
