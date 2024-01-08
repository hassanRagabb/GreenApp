import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GardenerProfile {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String description;
  final String city;

  GardenerProfile({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.description,
    required this.city,
  });
}

class GardenerProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<GardenerProfile?> getUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final docSnapshot =
          await _firestore.collection('Gardners').doc(user.email).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          // Add null check here
          return GardenerProfile(
            firstName: data['first_name'] ?? '',
            lastName: data['last_name'] ?? '',
            phoneNumber: data['phone_number'] ?? '',
            city: data['City'] ?? '',
            description: data['Description'] ?? '',
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
    String? description,
    String? city,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('Gardners').doc(user.email).update({
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'Description': description,
        'City': city,
      });
    }
  }
}

class EditGardProfileScreen extends StatefulWidget {
  const EditGardProfileScreen({super.key});

  @override
  _EditGardProfileScreenState createState() => _EditGardProfileScreenState();
}

class _EditGardProfileScreenState extends State<EditGardProfileScreen> {
  final GardenerProfileController _profileController =
      GardenerProfileController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _cityController = TextEditingController();

  GardenerProfile? _gardenerProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userProfile = await _profileController.getUserProfile();
    setState(() {
      _gardenerProfile = userProfile;
      _firstNameController.text = userProfile?.firstName ?? '';
      _lastNameController.text = userProfile?.lastName ?? '';
      _phoneNumberController.text = userProfile?.phoneNumber ?? '';
      _descriptionController.text = userProfile?.description ?? '';

      dropdownValue2 =
          _findDropdownItem2(userProfile?.city, dropdownItems2) ?? ' ';
    });
  }

  String? _findDropdownItem2(String? value, List<String> dropdownItems2) {
    for (String item in dropdownItems2) {
      if (item == value) {
        return item;
      }
    }
    return null;
  }

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

  String dropdownValue2 = ' ';

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
            _buildTextField(_descriptionController, 'Description'),
            const SizedBox(height: 16.0),
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
        description: _descriptionController.text,
        city: dropdownValue2);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }
}
