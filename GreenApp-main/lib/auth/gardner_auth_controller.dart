import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import '../login_page.dart';

class GardnerAuthController extends GetxController {
  static GardnerAuthController get to => Get.find();
  late Rx<User?> _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool isGardner = false.obs;

  User? get user => _user.value;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(_auth.currentUser);
    _user.bindStream(_auth.userChanges());
    ever(_user, _initialScreen);
  }

  void _initialScreen(User? user) {
    if (user == null) {
      print("login page");
      Get.offAll(() => const LoginPage());
    } else {
      // Check if the user is a Gardner
      checkGardner(user.email ?? '');
    }
  }

  Future<void> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String phone,
    File? profileImageFile,
    File? idImageFile,
    String averagePrice,
    String city,
    String description,
  ) async {
    if (email.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty ||
        city.isEmpty ||
        averagePrice.isEmpty ||
        description.isEmpty ||
        profileImageFile == null ||
        idImageFile == null) {
      Get.snackbar(
        "Account Creation Failed",
        "Please fill all the fields",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Account Creation Failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: const Text(
          "Please fill all the fields",
          style: TextStyle(color: Colors.white),
        ),
      );
      return;
    }

    try {
      // Upload the profile photo and get the photo URL
      String profilePhotoURL = '';
      profilePhotoURL = await uploadProfilePhotoAndGetURL(profileImageFile);

      // Upload the ID photo and get the photo URL
      String idPhotoURL = '';
      idPhotoURL = await uploadIDPhotoAndGetURL(idImageFile);

      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        await addGardnerDetails(user.uid, firstName, lastName, email, phone,
            profilePhotoURL, idPhotoURL, city, averagePrice, description);

        FirebaseFirestore.instance
            .collection('Gardners')
            .doc(user.email)
            .update({
          'profilePhotoURL': profilePhotoURL,
          'idPhotoURL': idPhotoURL,
        });
      }

      Get.offAll(() => const LoginPage());
    } catch (e) {
      Get.snackbar(
        "About User",
        "User message",
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Account Creation failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Future<void> addGardnerDetails(
    String userId,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String photoURL,
    String idPhotoURL,
    String city,
    String averagePrice,
    String description,
  ) async {
    try {
      DocumentReference gardnerRef =
          FirebaseFirestore.instance.collection('Gardners').doc(email);

      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await gardnerRef.get() as DocumentSnapshot<Map<String, dynamic>>;
      if (snapshot.exists) {
        print('Document $email already exists!');
        return;
      }

      await gardnerRef.set({
        'userId': userId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'profilePhotoURL': photoURL,
        'idPhotoURL': idPhotoURL,
        'City': city,
        'averagePrice': averagePrice,
        'rating': 0,
        'totalRatings': 0,
        'Description': description,
        'reviews': [],
      });
    } catch (e) {
      print('Error adding Gardner details: $e');
    }
  }

  Future<bool> loginGardner(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = _auth.currentUser;
      if (user != null) {
        final bool isGardner = await checkGardner(email);
        if (!isGardner) {
          // Throw an error message instead of an exception
          throw "No Gardner with these credentials was found!";
        }
      }
      // If checkSeller doesn't throw an exception, the login is successful
      return true;
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Login Failed"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: const Text("No Gardner with these credentials was found!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.green, // Set the color to green
                  ),
                ),
              ),
            ],
          );
        },
      );

      return false;
    }
  }

  Future<bool> checkGardner(String? email) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection("Gardners")
            .doc(email)
            .get();

    return snapshot.exists;
  }

  Future<void> updateGardnerDetails(
    String userId,
    String firstName,
    String lastName,
    String phoneNumber,
  ) async {
    try {
      String documentName = userId;
      DocumentReference GardnerRef =
          FirebaseFirestore.instance.collection('Gardners').doc(documentName);

      await GardnerRef.update({
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
      });
    } catch (e) {
      Get.snackbar(
        "Update Failed",
        e.toString(),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Update Failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void logOut() async {
    await _auth.signOut();
  }

  Future<String> uploadProfilePhotoAndGetURL(File imageFile) async {
    try {
      // Generate a unique filename for the image
      String fileName = path.basename(imageFile.path);

      // Create a reference to the location where the file will be uploaded
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child(fileName);

      // Upload the file to Firebase Storage
      await ref.putFile(imageFile);

      // Retrieve the download URL for the uploaded file
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading profile photo: $e');
      rethrow;
    }
  }

  Future<String> uploadIDPhotoAndGetURL(File imageFile) async {
    try {
      // Generate a unique filename for the image
      String fileName = path.basename(imageFile.path);

      // Create a reference to the location where the file will be uploaded
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('id_photos')
          .child(fileName);

      // Upload the file to Firebase Storage
      await ref.putFile(imageFile);

      // Retrieve the download URL for the uploaded file
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading ID photo: $e');
      rethrow;
    }
  }
}
