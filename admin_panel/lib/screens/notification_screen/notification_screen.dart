import 'package:admin_panel/constants/constants.dart';
import 'package:admin_panel/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _body = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Constants.primaryColor.withOpacity(.15),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Notification Screen',
                    style: TextStyle(
                      color: Color(0xff296e48),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          const SizedBox(
            height: 100.0,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _title,
                  decoration: InputDecoration(
                    hintText: "Notification Title",
                    filled: true,
                    fillColor: const Color(0xFFE5ECE8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff296e48),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                TextFormField(
                  controller: _body,
                  decoration: InputDecoration(
                    hintText: "Notification Body",
                    filled: true,
                    fillColor: const Color(0xFFE5ECE8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff296e48),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Constants.primaryColor,
                //     borderRadius: BorderRadius.circular(10),
                //     boxShadow: [
                //       BoxShadow(
                //         offset: const Offset(0, 1),
                //         blurRadius: 5,
                //         color: Constants.primaryColor.withOpacity(.3),
                //       ),
                //     ],
                //   ),
                //   child: TextButton(
                //     onPressed: () {
                //       if (_body.text.isNotEmpty && _title.text.isNotEmpty) {
                //         sendNotificationToAllUsers(
                //             appProvider.getUsersToken, _title.text, _body.text);
                //         _title.clear();
                //         _body.clear();
                //       } else {
                //         showMessage("Fill The details");
                //       }
                //     },
                //     child: const Center(
                //       child: Text(
                //         'Send Notification !',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 20.0,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Future<void> sendNotificationToAllUsers(
//     List<String?> usersToken, String title, String body) async {
//   List<String> newAllUserToken = [];
//   List<String> allUserToken = [];

//   for (var element in usersToken) {
//     if (element != null || element != "") {
//       newAllUserToken.add(element!);
//     }
//   }
//   allUserToken = newAllUserToken;
//   // Replace 'YOUR_SERVER_KEY' with your Firebase Cloud Messaging server key
//   const String serverKey =
//       'AAAAhQYpZOk:APA91bHBQCrAkLfzbpXOCM8VG-uDxxcNtEd4wEuRAFCtdvJhzSuiPghWRC-5KbI0RQMhveMm2gpezBV90AfziHOjyvoBYY25h7ONslwdH5ywJy4LPmSLZVVkvzLD6ZsKKPVqB7sb0MSE';

//   const String firebaseUrl = 'https://fcm.googleapis.com/fcm/send';

//   final Map<String, String> headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'key=$serverKey',
//   };

//   final Map<String, dynamic> notification = {
//     'title': title,
//     'body': body,
//   };

//   final Map<String, dynamic> requestBody = {
//     'notification': notification,
//     'priority': 'high',
//     'registration_ids': allUserToken,
//   };

//   final String encodedBody = jsonEncode(requestBody);

//   final http.Response response = await http.post(
//     Uri.parse(firebaseUrl),
//     headers: headers,
//     body: encodedBody,
//   );

//   if (response.statusCode == 200) {
//     print('Notification sent successfully.');
//   } else {
//     print('Notification sending failed with status: ${response.statusCode}');
//   }
// }
