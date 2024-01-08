import 'package:Green/Gardner/gardManagaProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Green/Gardner/clientInformation.dart';

class GardenerHomePage extends StatelessWidget {
  const GardenerHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String gardenerId = currentUser?.email ?? '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
      
      
      
      
        appBar: AppBar(
          title: Container(
            margin: const EdgeInsets.only(top: 2),
            child: const Text('Gardener Home',
                style: TextStyle(
                    fontSize: 23,
                    color: Color(0xff296e48),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'times new roman')),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black, size: 27),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, color: Color(0xff296e48)),
              onPressed: () {
                // Navigate to manage profile screen
                // Replace 'ManageProfileScreen' with your desired screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditGardProfileScreen(),
                  ),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 241, 236, 236),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        labelColor: const Color(
                            0xff296e48), // Change the selected tab text color
                        unselectedLabelColor: const Color.fromARGB(255, 0, 0,
                            0), // Change the unselected tab text color
                        tabs: const [
                          Tab(
                            text: 'Upcoming Requests',
                            icon: Icon(Icons.pending_actions),
                          ),
                          Tab(
                            text: 'Accepted Requests',
                            icon: Icon(Icons.check_circle_outline),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),













        body: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: TabBarView(
            children: [
              _buildUpcomingRequests(context, gardenerId),
              _buildAcceptedRequests(context, gardenerId),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingRequests(BuildContext context, String gardenerId) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('BookingRequests')
          .where('gardenerId', isEqualTo: gardenerId)
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> requests =
              snapshot.data!.docs;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> request = requests[index].data();
              String customerId = request['customerId'];
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(customerId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic>? customerData =
                        snapshot.data!.data() as Map<String, dynamic>?;

                    String customerFullName = '';
                    String customerCity = '';
                    String profilePhotoUrl =
                        ''; // Added variable for profile photo URL
                    if (customerData != null) {
                      String firstName = customerData['first_name'] ?? '';
                      String lastName = customerData['last_name'] ?? '';
                      customerFullName = '$firstName $lastName';
                      customerCity = customerData['City'] ?? '';
                      profilePhotoUrl = customerData['profile_photo_url'] ??
                          ''; // Retrieve profile photo URL
                    }

                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 23,
                            backgroundImage: profilePhotoUrl.isNotEmpty
                                ? NetworkImage(profilePhotoUrl)
                                : null,
                          ),
                          title: Row(
                            children: [
                              Text(customerFullName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 70, 68, 68),
                                      letterSpacing: 0,
                                      fontFamily: 'times new roman',
                                      height: 1.5)),
                              const SizedBox(width: 36),
                              const Icon(
                                Icons.location_on,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              Text(customerCity,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 223, 51, 51),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'times new roman',
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(width: 50),
                            ElevatedButton(
                              //change the width of the button
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(130, 35),
                                backgroundColor: const Color(0xff296e48),
                              ),
                              onPressed: () {
                                _acceptRequest(context, requests[index].id);
                              },
                              child: const Text('Accept'),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              //change color of the button
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(130, 35),
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                _rejectRequest(context, requests[index].id);
                              },
                              child: const Text('Reject'),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching customer data');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Text('Error fetching requests');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }










  Widget _buildAcceptedRequests(BuildContext context, String gardenerId) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('BookingRequests')
          .where('gardenerId', isEqualTo: gardenerId)
          .where('status', isEqualTo: 'accepted')
          .snapshots(),
      builder: (context, snapshot) {
        try {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> requests =
                snapshot.data!.docs;
            if (requests.isEmpty) {
              return const Text('No accepted requests');
            }
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> request = requests[index].data();
                String customerId = request['customerId'];
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(customerId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    try {
                      if (snapshot.hasData) {
                        Map<String, dynamic>? customerData =
                            snapshot.data!.data() as Map<String, dynamic>?;

                        if (customerData != null) {
                          String firstName = customerData['first_name'] ?? '';
                          String lastName = customerData['last_name'] ?? '';
                          String customerFullName = '$firstName $lastName';
                          String customerCity = customerData['City'] ?? '';
                          String profilePhotoUrl =
                              customerData['profile_photo_url'] ?? '';

                          return Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 23,
                                  backgroundImage: profilePhotoUrl.isNotEmpty
                                      ? NetworkImage(profilePhotoUrl)
                                      : null,
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      customerFullName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 70, 68, 68),
                                        letterSpacing: 0,
                                        fontFamily: 'times new roman',
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(width: 36),
                                    const Icon(
                                      Icons.location_on,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    Text(
                                      customerCity,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 223, 51, 51),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'times new roman',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const SizedBox(width: 50),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(130, 35),
                                      backgroundColor: const Color(0xff296e48),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ClientInformationScreen(
                                            customerId: customerId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('View Customer'),
                                  ),
                                  const SizedBox(width: 20),
                                  // ElevatedButton(
                                  //   style: ElevatedButton.styleFrom(
                                  //     minimumSize: const Size(130, 35),
                                  //     backgroundColor: Colors.red,
                                  //   ),
                                  //   onPressed: () {
                                  //     _removeCustomer(
                                  //         context, requests[index].id);
                                  //   },
                                  //   child: const Text('Remove'),
                                  // ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        } else {
                          return const Text('Customer data is empty');
                        }
                      } else if (snapshot.hasError) {
                        return const Text('Error fetching customer data');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    } catch (error) {
                      print('Error in inner StreamBuilder: $error');
                      return const Text('An error occurred');
                    }
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Text('Error fetching requests');
          } else {
            return const CircularProgressIndicator();
          }
        } catch (error) {
          print('Error in StreamBuilder: $error');
          return const Text('An error occurred');
        }
      },
    );
  }







  void _acceptRequest(BuildContext context, String requestId) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await FirebaseFirestore.instance
            .collection('BookingRequests')
            .doc(requestId)
            .update({'status': 'accepted', 'location': 'accepted_requests'});
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Request accepted')),
        );
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Failed to accept request')),
        );
      }
    });
  }

  void _rejectRequest(BuildContext context, String requestId) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await FirebaseFirestore.instance
            .collection('BookingRequests')
            .doc(requestId)
            .update({'status': 'rejected'});
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Request rejected')),
        );
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Failed to reject request')),
        );
      }
    });
  }

  void _removeCustomer(BuildContext context, String requestId) {
    // Update the document in Firestore
    FirebaseFirestore.instance
        .collection('BookingRequests')
        .doc(requestId)
        .update({'status': 'removed by gardener'}).then((_) {
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer removed successfully')),
      );
    }).catchError((error) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove customer')),
      );
    });
  }
}
