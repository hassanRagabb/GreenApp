// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class GardenerProfile extends StatefulWidget {
//   final String gardenerId;

//   const GardenerProfile({Key? key, required this.gardenerId}) : super(key: key);

//   @override
//   _GardenerProfileState createState() => _GardenerProfileState();
// }

// class _GardenerProfileState extends State<GardenerProfile> {
//   late Future<DocumentSnapshot> gardenerFuture;

//   @override
//   void initState() {
//     super.initState();
//     gardenerFuture = fetchGardener(widget.gardenerId);
//   }

//   Future<DocumentSnapshot> fetchGardener(String gardenerId) async {
//     return FirebaseFirestore.instance
//         .collection('Gardners')
//         .doc(gardenerId)
//         .get();
//   }

//   Future<void> sendBookingRequest(
//       BuildContext context, String gardenerId) async {
//     final User? user = FirebaseAuth.instance.currentUser;
//     final String customerId =
//         user?.email ?? ''; // Replace with actual customer ID
//     final timestamp = DateTime.now();

//     try {
//       await FirebaseFirestore.instance.collection('BookingRequests').add({
//         'customerId': customerId,
//         'gardenerId': gardenerId,
//         'status': 'pending',
//         'timestamp': timestamp,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Booking request sent')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to send booking request')),
//       );
//     }
//   }

//   void _handleBookButtonPressed(String gardenerId) {
//     sendBookingRequest(context, gardenerId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Gardener Profile'),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: gardenerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasData && snapshot.data != null) {
//             final gardenerData = snapshot.data!.data() as Map<String, dynamic>;

//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       backgroundImage:
//                           NetworkImage(gardenerData['profilePhotoURL']),
//                       radius: 50.0,
//                     ),
//                     const SizedBox(height: 16.0),
//                     Text(
//                       '${gardenerData['first_name']} ${gardenerData['last_name']}',
//                       style: const TextStyle(
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8.0),
//                     Text(
//                       'City: ${gardenerData['City']}',
//                       style: const TextStyle(fontSize: 16.0),
//                     ),
//                     const SizedBox(height: 8.0),
//                     Text(
//                       'Average Price: ${gardenerData['averagePrice']}',
//                       style: const TextStyle(fontSize: 16.0),
//                     ),
//                     const SizedBox(height: 8.0),
//                     Text(
//                       'Phone Number: ${gardenerData['phone_number']}',
//                       style: const TextStyle(fontSize: 16.0),
//                     ),
//                     const SizedBox(height: 8.0),
//                     Text(
//                       'Rating: ${gardenerData['rating'].toDouble()}',
//                       style: const TextStyle(fontSize: 16.0),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         _handleBookButtonPressed(widget.gardenerId);
//                       },
//                       child: const Text('Book'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           return const Center(child: Text('Failed to load gardener profile'));
//         },
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Chat/ChatScreen.dart';

class AcceptedGardenerProfile extends StatefulWidget {
  final String gardenerId;

  const AcceptedGardenerProfile({Key? key, required this.gardenerId})
      : super(key: key);

  @override
  _AcceptedGardenerProfileState createState() =>
      _AcceptedGardenerProfileState();
}

class _AcceptedGardenerProfileState extends State<AcceptedGardenerProfile> {
  late Future<DocumentSnapshot> gardenerFuture;
  String? chatRoomId;

  @override
  void initState() {
    super.initState();
    gardenerFuture = fetchGardener(widget.gardenerId);
  }

  Future<DocumentSnapshot> fetchGardener(String gardenerId) async {
    return FirebaseFirestore.instance
        .collection('Gardners')
        .doc(gardenerId)
        .get();
  }

  Future<bool> checkPendingRequest(String gardenerId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String customerId =
        user?.email ?? ''; // Replace with actual customer ID

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('BookingRequests')
        .where('customerId', isEqualTo: customerId)
        .where('gardenerId', isEqualTo: gardenerId)
        .where('status', isEqualTo: 'pending')
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<bool> checkAcceptedRequest(String gardenerId) async {
    // Query the BookingRequests collection to check if any request for the given gardener has been accepted
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('BookingRequests')
        .where('gardenerId', isEqualTo: gardenerId)
        .where('status', isEqualTo: 'accepted')
        .limit(1) // Limit the query to only one result
        .get();

    return snapshot.size >
        0; // Return true if at least one accepted request is found
  }

  Future<void> sendBookingRequest(
      BuildContext context, String gardenerId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String customerId =
        user?.email ?? ''; // Replace with actual customer ID

    bool isPending = await checkPendingRequest(gardenerId);

    if (isPending) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Request Already Sent'),
            content:
                const Text('You have already sent a request to this gardener.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Check if the gardener has already accepted a request
      bool isAccepted = await checkAcceptedRequest(gardenerId);

      if (isAccepted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Request Unavailable'),
              content:
                  const Text('This gardener has already accepted a request.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Send the booking request
        await FirebaseFirestore.instance.collection('BookingRequests').add({
          'customerId': customerId,
          'gardenerId': gardenerId,
          'status': 'pending',
        });

        // Show success message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Request Sent'),
              content: const Text(
                  'Your booking request has been sent successfully.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  String generateChatRoomId(String customerId, String gardenerId) {
    // Sort the user IDs to ensure consistent chat room IDs
    List<String> sortedIds = [customerId, gardenerId]..sort();

    // Concatenate the sorted user IDs to create the chat room ID
    String chatRoomId = sortedIds.join('_');

    return chatRoomId;
  }

  void _startChat(BuildContext context, String? chatRoomId) {
    if (chatRoomId == null) {
      // Create a new chat room
      String customerId = FirebaseAuth.instance.currentUser?.uid ?? '';
      String gardenerId = widget.gardenerId;

      // Generate a unique chat room ID
      String newChatRoomId = generateChatRoomId(customerId, gardenerId);

      // Save the new chat room ID to the database
      FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(newChatRoomId)
          .set({
        'customer_id': customerId,
        'gardener_id': gardenerId,
        'created_at': DateTime.now(),
      }).then((_) {
        // Navigate to the chat screen with the new chat room ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chatRoomId: newChatRoomId),
          ),
        );
      }).catchError((error) {
        print('Error creating chat room: $error');
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create chat room')),
        );
      });
    } else {
      // Navigate to the chat screen with the existing chat room ID
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(chatRoomId: chatRoomId),
        ),
      );
    }
  }

  // void _handleBookButtonPressed(String gardenerId) {
  //   sendBookingRequest(context, gardenerId);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Gardener Information',
          style: TextStyle(color: Color.fromARGB(255, 26, 142, 42)),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: gardenerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            final gardenerData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(gardenerData['profilePhotoURL']),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${gardenerData['first_name']} ${gardenerData['last_name']}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'times new roman',
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 189, 185, 185),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('City', Icons.location_on, gardenerData['City']),
                const SizedBox(height: 16),
                const Divider(
                  color: Color.fromARGB(255, 189, 185, 185),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Average Price', Icons.attach_money,
                    gardenerData['averagePrice']),
                const SizedBox(height: 16),
                const Divider(
                  color: Color.fromARGB(255, 189, 185, 185),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                    'Phone Number', Icons.phone, gardenerData['phone_number']),
                const SizedBox(height: 16),
                const Divider(
                  color: Color.fromARGB(255, 189, 185, 185),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                    'Rating', Icons.star, '${gardenerData['rating']}/ 5'),
                const SizedBox(height: 16),
                const Divider(
                  color: Color.fromARGB(255, 189, 185, 185),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Description', Icons.description,
                    gardenerData['Description']),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff296e48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () {
                    if (chatRoomId == null) {
                      String customerId =
                          FirebaseAuth.instance.currentUser?.email ?? '';
                      chatRoomId =
                          generateChatRoomId(customerId, widget.gardenerId);
                    }
                    _startChat(context, chatRoomId!);
                  },
                  child: const Text('Open Chat'),
                ),
                const SizedBox(height: 16),
              ],
            );
          }

          return const Center(child: Text('Failed to load gardener profile'));
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, IconData iconData, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 22,
            color: const Color.fromARGB(136, 43, 151, 10),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'times new roman',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
