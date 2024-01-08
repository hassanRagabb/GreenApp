import 'package:Green/Green_Store/screens/bottom_bar/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Green/Customer/reminder_page.dart';

import '../auth/user_auth_controller.dart';
import '../login_page.dart';
import '../add_plant.dart';
import 'bookGardener.dart';
import 'view_plants.dart';
import 'manage_profile.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, Key? key1});

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'img/f.png',
      'img/Instagram_icon.png',
    ];

    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(top: 30, bottom: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.menu,
                        size: 35,
                        color: Color(0xff296e48),
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        UserAuthController().logOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10, top: 5),
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('img/logout.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 130),
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Green',
                      style: TextStyle(
                        fontSize: 60,
                        color: Color(0xff296e48),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.grass,
                      size: 60,
                      color: Color.fromARGB(255, 24, 190, 29),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Column(
                children: [
                  Text(
                    'We provide our Gardners with',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 74, 71, 71),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'everything from booking',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 74, 71, 71),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'gardeners, getting in contact with',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 74, 71, 71),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'expert advisors, online store, reminders,',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 74, 71, 71),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'tips, and plant information.',
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 74, 71, 71),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle click for the first image (Facebook)
                      print('Facebook image tapped');
                      launch(
                          'https://www.facebook.com/profile.php?id=100094541194009');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[500],
                        child: const CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage('img/f.png'),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle click for the second image (Instagram)
                      print('insta image tapped');
                      launch('https://www.instagram.com/');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[500],
                        child: const CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage('img/Instagram_icon.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '© 2023 Green App. All rights reserved.',
                      style: TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff296e48),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(UserAuthController.instance.user?.email)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error retrieving name');
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    final data = snapshot.data?.data() as Map<String, dynamic>;
                    final firstName = data['first_name'] ?? '';
                    final lastName = data['last_name'] ?? '';
                    final fullName = '$firstName $lastName';

                    return Text(
                      fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  }

                  return const Text('Loading name');
                },
              ),
              accountEmail: Text(UserAuthController.instance.user?.email ?? ''),
              // currentAccountPicture: const CircleAvatar(
              //   backgroundColor: Color.fromARGB(255, 232, 228, 228),
              //   child: Icon(
              //     Icons.person,
              //     color: Color.fromARGB(255, 125, 123, 123),
              //     size: 35,
              //   ),
              // ),
              currentAccountPicture: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(UserAuthController.instance.user?.email)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 232, 228, 228),
                      child: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 125, 123, 123),
                        size: 35,
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    final data = snapshot.data?.data() as Map<String, dynamic>;
                    final photoUrl = data['profile_photo_url'];

                    return CircleAvatar(
                      backgroundImage:
                          NetworkImage(photoUrl ?? ''), // Load image from URL
                    );
                  }

                  return const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 232, 228, 228),
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              decoration: const BoxDecoration(
                color: Color(0xff296e48),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text('Reminders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SchedulingScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.grass),
              title: const Text('View Plants'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlantPage()),
                );
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.grass),
            //   title: const Text('add plant'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const AddPlantPage()),
            //     );
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.engineering),
              title: const Text('Book Gardener'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomerBookingScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_basket),
              title: const Text('Green Store'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BottomBar()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.tips_and_updates),
              title: const Text('Tips'),
              onTap: () async {
                QuerySnapshot tipsSnapshot =
                    await FirebaseFirestore.instance.collection('tips').get();
                List<Map<String, dynamic>> tipsData = tipsSnapshot.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();
                Map<String, dynamic>? randomTip =
                    tipsData[Random().nextInt(tipsData.length)];

                showDialog(
                  context: context,
                  builder: (context) => Stack(
                    children: [
                      // Background overlay
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: Colors.black54,
                        ),
                      ),
                      // Dialog content
                      AlertDialog(
                        backgroundColor: Colors.transparent,
                        contentPadding: EdgeInsets.zero,
                        content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                randomTip['title'] as String,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    randomTip['tipImageURL'] as String,
                                    width: 300.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                randomTip['text'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              side: const BorderSide(color: Colors.green),
                            ),
                            child: const Text(
                              'Close',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                        elevation: 0,
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.manage_accounts_rounded),
              title: const Text('Manage Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
