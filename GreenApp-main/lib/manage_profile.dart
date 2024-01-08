import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String gardenSize;
  final String budget;
  final String category;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.gardenSize,
    required this.budget,
    required this.category,
  });
}

class UserProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile?> getUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final docSnapshot =
          await _firestore.collection('users').doc(user.uid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          // Add null check here
          return UserProfile(
            firstName: data['first_name'] ?? '',
            lastName: data['last_name'] ?? '',
            phoneNumber: data['phone_number'] ?? '',
            gardenSize: data['garden_size'] ?? '',
            budget: data['budget'] ?? '',
            category: data['category'] ?? '',
          );
        }
      }
    }
    return null;
  }

  Future<void> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? gardenSize,
    String? budget,
    String? category,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'garden_size': gardenSize,
        'budget': budget,
        'category': category,
      });
    }
  }
}

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserProfileController _profileController = UserProfileController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  //final TextEditingController _gardenSizeController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _dropdownController = TextEditingController();

  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userProfile = await _profileController.getUserProfile();
    setState(() {
      _userProfile = userProfile;
      _firstNameController.text = userProfile?.firstName ?? '';
      _lastNameController.text = userProfile?.lastName ?? '';
      _phoneNumberController.text = userProfile?.phoneNumber ?? '';
      //_gardenSizeController.text = userProfile?.gardenSize ?? '';
      _budgetController.text = userProfile?.budget ?? '';
      _categoryController.text = userProfile?.category ?? '';

      dropdownValue =
          _findDropdownItem(userProfile?.gardenSize, dropdownItems) ?? '';
    });
  }

  String? _findDropdownItem(String? value, List<String> dropdownItems) {
    for (String item in dropdownItems) {
      if (item == value) {
        return item;
      }
    }
    return null;
  }

  List<String> dropdownItems = [
    '',
    'Small     < 30 m2',
    'Medium      30 - 60 m2',
    'Large      > 60 m2',
  ];

  String dropdownValue = '';

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Edit Profile'),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: ListView(
  //         children: [
  //           TextFormField(
  //             controller: _firstNameController,
  //             decoration: const InputDecoration(
  //               labelText: 'First Name',
  //             ),
  //           ),
  //           const SizedBox(height: 16.0),
  //           TextFormField(
  //             controller: _lastNameController,
  //             decoration: const InputDecoration(
  //               labelText: 'Last Name',
  //             ),
  //           ),
  //           const SizedBox(height: 16.0),
  //           TextFormField(
  //             controller: _phoneNumberController,
  //             decoration: const InputDecoration(
  //               labelText: 'Phone Number',
  //             ),
  //           ),
  //           const SizedBox(height: 25.0),
  //           Container(
  //             margin: const EdgeInsets.only(right: 170),
  //             child: const Text(
  //               'Size of your garden:',
  //               style: TextStyle(
  //                 color: Color.fromARGB(255, 99, 101, 98),
  //                 fontSize: 14,
  //                 //fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           Container(
  //             margin: const EdgeInsets.symmetric(horizontal: 20),
  //             width: 300, // Set the width of the dropdown button
  //             child: DropdownButton<String>(
  //               value: dropdownValue,
  //               onChanged: (String? value) {
  //                 setState(() {
  //                   dropdownValue = value!;
  //                   _dropdownController.text = value;
  //                 });
  //               },
  //               items:
  //                   dropdownItems.map<DropdownMenuItem<String>>((String value) {
  //                 return DropdownMenuItem<String>(
  //                   value: value,
  //                   child: Text(value),
  //                 );
  //               }).toList(),
  //               icon: const Icon(Icons.arrow_drop_down), // Set the icon
  //               iconSize: 30, // Set the size of the icon
  //               elevation: 16,
  //               style: const TextStyle(
  //                 color: Color.fromARGB(255, 84, 87, 84),
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //               underline: Container(
  //                 height: 2,
  //                 color: Colors.grey[300],
  //               ),
  //               dropdownColor: Colors.white,
  //               isExpanded: true, // Set isExpanded to true
  //             ),
  //           ),
  //           const SizedBox(height: 16.0),
  //           TextFormField(
  //             controller: _budgetController,
  //             decoration: const InputDecoration(
  //               labelText: 'Budget',
  //             ),
  //           ),
  //           //'What category does your garden belong to (ex: coffee)?',
  //           const SizedBox(height: 16.0),
  //           TextFormField(
  //             controller: _categoryController,
  //             decoration: const InputDecoration(
  //               labelText: 'Category (ex: coffee)',
  //             ),
  //           ),
  //           const SizedBox(height: 16.0),
  //           ElevatedButton(
  //             onPressed: _updateProfile,
  //             child: const Text('Update'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.green),
        title: const Text(
          'Manage Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.green,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 25.0),
            _buildTextField(_firstNameController, 'First Name'),
            const SizedBox(height: 16.0),
            _buildTextField(_lastNameController, 'Last Name'),
            const SizedBox(height: 16.0),
            _buildTextField(_phoneNumberController, 'Phone Number'),
            const SizedBox(height: 25.0),
            const Text(
              'Size of your garden:',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                    _dropdownController.text = value;
                  });
                },
                items: dropdownItems.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            ),
            const SizedBox(height: 16.0),
            _buildTextField(_budgetController, 'Budget'),
            const SizedBox(height: 16.0),
            _buildTextField(_categoryController, 'Category'),
            const SizedBox(height: 50.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onPressed: _updateProfile,
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    await _profileController.updateUserProfile(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneNumberController.text,
      gardenSize: _dropdownController.text,
      budget: _budgetController.text,
      category: _categoryController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }
}
