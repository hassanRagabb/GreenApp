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
  final String city;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.gardenSize,
    required this.budget,
    required this.category,
    required this.city,
  });
}

class UserProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile?> getUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final docSnapshot =
          await _firestore.collection('users').doc(user.email).get();
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
            city: data['City'] ?? '',
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
    String? city,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.email).update({
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'garden_size': gardenSize,
        'budget': budget,
        'category': category,
        'City': city,
      });
    }
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

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
  final TextEditingController _cityController = TextEditingController();

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
      dropdownValue2 =
          _findDropdownItem2(userProfile?.city, dropdownItems2) ?? ' ';
      dropdownValue3 =
          _findDropdownItem3(userProfile?.category, dropdownItems3) ?? 'Coffee';
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

  String? _findDropdownItem2(String? value, List<String> dropdownItems2) {
    for (String item in dropdownItems2) {
      if (item == value) {
        return item;
      }
    }
    return null;
  }

  String? _findDropdownItem3(String? value, List<String> dropdownItems3) {
    for (String item in dropdownItems3) {
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
  List<String> dropdownItems2 = [
    ' ',
    'Abu Simbel',
    'Alexandria',
    'Aswan',
    'Asyut',
    'Banha',
    'Beni Suef',
    'Cairo',
    'Damanhur',
    'Damietta',
    'El Mahalla El Kubra',
    'El Mansoura',
    'El Minya',
    'Faiyum',
    'Giza',
    'Ismaïlia',
    'Kafr El Sheikh',
    'New Cairo',
    'Port Said',
    'Qena',
    'Tanta',
    'Zagazig'
  ];
  List<String> dropdownItems3 = [
    'Coffee',
    'Home',
    'Club',
    'Office',
    'landscape',
    'Other'
  ];
  String dropdownValue = '';
  String dropdownValue2 = ' ';
  String dropdownValue3 = 'Coffee';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xff296e48)),
        title: const Text(
          'Manage Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xff296e48),
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
            const Text(
              'City:',
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
                value: dropdownValue2,
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue2 = value!;
                    _cityController.text = value;
                  });
                },
                items: dropdownItems2.map<DropdownMenuItem<String>>(
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
            const Text(
              'Category of your garden:',
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
                value: dropdownValue3,
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue3 = value!;
                    _categoryController.text = value;
                  });
                },
                items: dropdownItems3.map<DropdownMenuItem<String>>(
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
            const SizedBox(height: 15.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xff296e48),
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
      city: _cityController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }
}
