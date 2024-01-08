import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Chat/ChatScreen.dart';

class ClientInformationScreen extends StatefulWidget {
  final String customerId;

  const ClientInformationScreen({super.key, required this.customerId});

  @override
  _ClientInformationScreenState createState() =>
      _ClientInformationScreenState();
}

class _ClientInformationScreenState extends State<ClientInformationScreen> {
  String? chatRoomId;
  String generateChatRoomId(String customerId, String gardenerId) {
    // Sort the user IDs to ensure consistent chat room IDs
    List<String> sortedIds = [customerId, gardenerId]..sort();

    // Concatenate the sorted user IDs to create the chat room ID
    String chatRoomId = sortedIds.join('_');

    return chatRoomId;
  }

  Future<void> _openChat(BuildContext context) async {
    if (chatRoomId != null) {
      // The chat room already exists, navigate to ChatScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(chatRoomId: chatRoomId!),
        ),
      );
    } else {
      // The chat room doesn't exist, create a new one
      final User? gardenerUser = FirebaseAuth.instance.currentUser;
      final String gardenerId = gardenerUser?.email ?? '';

      QuerySnapshot<Map<String, dynamic>> bookingSnapshot =
          await FirebaseFirestore.instance
              .collection('BookingRequests')
              .where('gardenerId', isEqualTo: gardenerId)
              .limit(1)
              .get();

      String customerId = '';
      if (bookingSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> bookingData = bookingSnapshot.docs.first.data();
        customerId = bookingData['customerId'] ?? '';
      }

      chatRoomId = generateChatRoomId(customerId, gardenerId);

      // Save the new chat room ID to the database
      FirebaseFirestore.instance.collection('ChatRooms').doc(chatRoomId).set({
        'customer_id': customerId,
        'gardener_id': gardenerId,
        'created_at': DateTime.now(),
      }).then((_) {
        // Navigate to the chat screen with the new chat room ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chatRoomId: chatRoomId!),
          ),
        );
      }).catchError((error) {
        print('Error creating chat room: $error');
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create chat room')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Client Information',
          style: TextStyle(color: Color(0xff296e48)),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.customerId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic>? customerData =
                snapshot.data!.data() as Map<String, dynamic>?;

            if (customerData != null) {
              String firstName = customerData['first_name'] ?? '';
              String lastName = customerData['last_name'] ?? '';
              String customerFullName = '$firstName $lastName';
              String customerCity = customerData['City'] ?? '';
              String phoneNumber = customerData['phone_number'] ?? '';
              String profilePhotoUrl = customerData['profile_photo_url'] ?? '';

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: profilePhotoUrl.isNotEmpty
                              ? NetworkImage(profilePhotoUrl)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          customerFullName,
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
                  _buildInfoRow('City', Icons.location_on, customerCity),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Color.fromARGB(255, 189, 185, 185),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Phone Number', Icons.phone, phoneNumber),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Color.fromARGB(255, 189, 185, 185),
                  ),
                  const SizedBox(height: 100),
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
                      _openChat(context);
                    },
                    child: const Text('Open Chat'),
                  )
                ],
              );
            }
          } else if (snapshot.hasError) {
            return const Text('Error fetching customer data');
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
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
