import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../auth/user_auth_controller.dart';
import '../login_page.dart';
import '../Customer/manage_profile.dart';

class SellerHomePage extends StatelessWidget {
  const SellerHomePage({super.key, Key? key1});

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
                        color: Color.fromARGB(255, 19, 105, 22),
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
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Green',
                      style: TextStyle(
                        fontSize: 60,
                        color: Color.fromARGB(255, 24, 190, 29),
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
              Column(
                children: const [
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
                  for (String image in images)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[500],
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage(image),
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
                          color: Color.fromARGB(255, 24, 190, 29),
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
                    .doc(UserAuthController.instance.user?.uid)
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
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 232, 228, 228),
                child: Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 125, 123, 123),
                  size: 35,
                ),
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 93, 172, 96),
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
              leading: const Icon(Icons.people_sharp),
              title: const Text('Expert Advisor'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SellerHomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.engineering),
              title: const Text('Book Gardener'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SellerHomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_basket),
              title: const Text('Products'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SellerHomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.tips_and_updates),
              title: const Text('Tips'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SellerHomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.grass),
              title: const Text('Learn about Plants'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SellerHomePage()),
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
